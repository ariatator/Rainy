import ActivityKit
import WidgetKit
import SwiftUI

struct WeatherLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WeatherAttributes.self) { context in
            // Lock screen / Banner UI
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .clear, .white.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .blur(radius: 1)
                            .offset(x: -1, y: -1)
                            .mask(RoundedRectangle(cornerRadius: 24))
                    )
                
                HStack {
                    TrackerIcon(type: context.attributes.trackingType)
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
                    TrackerIcon(type: context.attributes.trackingType)
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
                TrackerIcon(type: context.attributes.trackingType)
            } compactTrailing: {
                Text(context.state.primaryValue).foregroundColor(.white).font(.caption)
            } minimal: {
                TrackerIcon(type: context.attributes.trackingType)
            }
        }
    }
}

struct TrackerIcon: View {
    let type: TrackingType
    var body: some View {
        switch type {
        case .rain:
            Image(systemName: "cloud.rain.fill").foregroundColor(.blue)
        case .sunset:
            Image(systemName: "sunset.fill").foregroundColor(.orange)
        case .index:
            Image(systemName: "leaf.fill").foregroundColor(.green)
        }
    }
}
