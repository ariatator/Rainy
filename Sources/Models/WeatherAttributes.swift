import Foundation
import ActivityKit

enum TrackingType: String, Codable, Hashable, CaseIterable {
    case rain = "Rain Countdown"
    case sunset = "Sunset Tracker"
    case index = "Touch Grass Index"
}

struct WeatherAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var primaryValue: String // e.g. "15 min", "6:45 PM", "12/100"
        var conditionMessage: String
    }

    var trackingType: TrackingType
    var eventName: String
}
