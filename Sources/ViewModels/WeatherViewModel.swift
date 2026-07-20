import SwiftUI
import ActivityKit

class WeatherViewModel: ObservableObject {
    @Published var currentCondition: WeatherCondition
    @Published var hourlyForecasts: [HourlyForecast]
    @Published var dailyForecasts: [DailyForecast]
    
    private var currentActivity: Activity<WeatherAttributes>?
    
    init() {
        self.currentCondition = WeatherCondition(temperature: 72, condition: "Rain", description: "Light rain", windSpeed: 5, humidity: 80, uvIndex: 2, airQuality: 45)
        self.hourlyForecasts = [
            HourlyForecast(time: "Now", temperature: 72, iconName: "cloud.rain.fill"),
            HourlyForecast(time: "1 PM", temperature: 71, iconName: "cloud.rain.fill"),
            HourlyForecast(time: "2 PM", temperature: 72, iconName: "cloud.fill"),
            HourlyForecast(time: "3 PM", temperature: 74, iconName: "cloud.sun.fill"),
            HourlyForecast(time: "4 PM", temperature: 75, iconName: "sun.max.fill")
        ]
        self.dailyForecasts = [
            DailyForecast(day: "Mon", highTemp: 76, lowTemp: 60, iconName: "cloud.rain.fill"),
            DailyForecast(day: "Tue", highTemp: 78, lowTemp: 62, iconName: "sun.max.fill"),
            DailyForecast(day: "Wed", highTemp: 72, lowTemp: 58, iconName: "cloud.sun.fill")
        ]
    }
    
    var survivalIndex: Int {
        let temp = currentCondition.temperature
        if temp < 30 || temp > 100 { return 10 }
        if temp >= 65 && temp <= 80 { return 85 }
        return 50
    }
    
    func startCustomLiveActivity(type: TrackingType, persona: PersonaType) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = WeatherAttributes(trackingType: type, eventName: type.rawValue)
        
        var value = ""
        var message = ""
        
        switch type {
        case .rain:
            value = "15 min"
            message = persona == .snarky ? "Get an umbrella, idiot." : "Rain approaches."
        case .sunset:
            value = "8:30 PM"
            message = persona == .rpg ? "The Sun Orb descends." : "Sunset approaching."
        case .index:
            value = "\(survivalIndex)/100"
            message = persona == .hype ? "Vibe check incoming." : "Current Touch Grass Index."
        }
        
        let initialState = WeatherAttributes.ContentState(primaryValue: value, conditionMessage: message)
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil)
            )
            self.currentActivity = activity
        } catch {
            print("Error starting live activity: \(error)")
        }
    }
    
    func endLiveActivity() {
        Task {
            let state = WeatherAttributes.ContentState(primaryValue: "Done", conditionMessage: "Tracking finished.")
            await currentActivity?.end(ActivityContent(state: state, staleDate: nil), dismissalPolicy: .default)
        }
    }
}
