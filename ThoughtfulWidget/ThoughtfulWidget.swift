//
//  ThoughtfulWidget.swift
//  ThoughtfulWidget
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    @State var person: String = "3"

    func placeholder(in _: Context) -> ThoughtfulWidgetEntry {
        ThoughtfulWidgetEntry(date: Date())
    }

    func getSnapshot(in _: Context, completion: @escaping (ThoughtfulWidgetEntry) -> Void) {
        let entry = ThoughtfulWidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let entries: [ThoughtfulWidgetEntry] = [ThoughtfulWidgetEntry(date: currentDate)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ThoughtfulWidgetEntry: TimelineEntry {
    var date: Date
}

struct ThoughtfulWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var length: CGFloat {
        switch family {
        case .systemSmall:
            return 40
        case .systemMedium:
            return 60
        case .systemLarge:
            return 60
        case .systemExtraLarge:
            return 10
        case .accessoryCorner:
            return 10
        case .accessoryCircular:
            return 10
        case .accessoryRectangular:
            return 10
        case .accessoryInline:
            return 10
        @unknown default:
            return 40
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Image(.logo)
                .resizable()
                .frame(width: length, height: length)
                .foregroundStyle(.black)

            Text("Add Thought")
                .font(.title3)
                .bold()
            Text("Time to reflect and grow")
                .foregroundStyle(.secondary)

//            Spacer()

//            HStack {
//                Text("Today's thoughts")
//                    .font(.caption2)
//                    .bold()
//
//                Spacer()
//
//                Text("3")
//                    .font(.caption2)
//                    .foregroundStyle(.secondary)
//                    .bold()
//            }
        }
        .foregroundStyle(.black.opacity(0.8))
        .widgetURL(URL(string: "thoughtful://add"))
    }
}

struct ThoughtfulWidget: Widget {
    let kind: String = "ThoughtfulWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ThoughtfulWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color.widgetBackground
                    }
                    .foregroundStyle(.black)
            } else {
                ThoughtfulWidgetEntryView(entry: entry)
                    .padding()
                    .background(
                        Color.widgetBackground
                    )
                    .foregroundStyle(.black)
            }
        }
        .configurationDisplayName("Add Thought")
        .description("A widget to add a Thought from your home screen!")
    }
}

#Preview(as: .systemSmall) {
    ThoughtfulWidget()
} timeline: {
    ThoughtfulWidgetEntry(date: .now)
}
