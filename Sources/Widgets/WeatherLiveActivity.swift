import ActivityKit
import WidgetKit
import SwiftUI

struct WeatherLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WeatherAttributes.self) { context in
            // Lock screen / Banner UI
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                
                HStack {
                    iconFor(type: context.attributes.trackingType)
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text(context.attributes.eventName)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(context.state.conditionMessage)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Text(context.state.primaryValue)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                .padding()
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded Region
                DynamicIslandExpandedRegion(.leading) {
                    iconFor(type: context.attributes.trackingType)
                        .font(.title2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.primaryValue)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.conditionMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            } compactLeading: {
                iconFor(type: context.attributes.trackingType)
            } compactTrailing: {
                Text(context.state.primaryValue).foregroundColor(.white).font(.caption)
            } minimal: {
                iconFor(type: context.attributes.trackingType)
            }
        }
    }
    
    @ViewBuilder
    func iconFor(type: TrackingType) -> some View {
        switch type {
        case .rain: Image(systemName: "cloud.rain.fill").foregroundColor(.blue)
        case .sunset: Image(systemName: "sunset.fill").foregroundColor(.orange)
        case .index: Image(systemName: "leaf.fill").foregroundColor(.green)
        }
    }
}
