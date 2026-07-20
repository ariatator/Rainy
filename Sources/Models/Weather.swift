import Foundation

struct WeatherCondition {
    let temperature: Int
    let condition: String
    let description: String
    let windSpeed: Int
    let humidity: Int
    let uvIndex: Int
    let airQuality: Int
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Int
    let iconName: String
}

struct DailyForecast: Identifiable {
    let id = UUID()
    let day: String
    let highTemp: Int
    let lowTemp: Int
    let iconName: String
}
