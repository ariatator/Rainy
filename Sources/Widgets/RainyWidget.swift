import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), temperature: 72, condition: "Rainy", quote: "You look like you need an umbrella.")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), temperature: 72, condition: "Rainy", quote: "You look like you need an umbrella.")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), temperature: 72, condition: "Rainy", quote: "You look like you need an umbrella.")
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let temperature: Int
    let condition: String
    let quote: String
}

struct RainyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "cloud.rain.fill")
                        .foregroundColor(.white)
                    Text("\(entry.temperature)°")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(entry.quote)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .italic()
            }
            .padding()
        }
    }
}

struct RainyWidget: Widget {
    let kind: String = "RainyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RainyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Rainy Forecast")
        .description("Snarky weather right on your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
