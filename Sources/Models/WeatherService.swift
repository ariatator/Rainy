import Foundation

struct OpenMeteoResponse: Codable {
    let current: CurrentWeather?
    let daily: DailyWeather?
}

struct CurrentWeather: Codable {
    let temperature_2m: Double
    let weather_code: Int
    let wind_speed_10m: Double
    let relative_humidity_2m: Double
}

struct DailyWeather: Codable {
    let uv_index_max: [Double]?
}

class WeatherService {
    func fetchWeather(lat: Double, lon: Double) async throws -> OpenMeteoResponse {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&daily=uv_index_max&temperature_unit=fahrenheit&wind_speed_unit=mph&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
    }
    
    static func condition(for code: Int) -> (condition: String, description: String, icon: String) {
        switch code {
        case 0: return ("Clear", "Clear sky", "sun.max.fill")
        case 1, 2, 3: return ("Cloudy", "Partly cloudy", "cloud.sun.fill")
        case 45, 48: return ("Fog", "Foggy", "cloud.fog.fill")
        case 51...55: return ("Drizzle", "Light drizzle", "cloud.drizzle.fill")
        case 61...65: return ("Rain", "Rain showers", "cloud.rain.fill")
        case 71...75: return ("Snow", "Snowfall", "snowflake")
        case 95...99: return ("Storm", "Thunderstorm", "cloud.bolt.rain.fill")
        default: return ("Unknown", "Unknown weather", "cloud.fill")
        }
    }
}
