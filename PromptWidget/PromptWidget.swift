//
//  PromptWidget.swift
//  PromptWidget
//
//  Created by Nabil Ridhwan on 18/6/24.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        gratitudeQuestions.randomElement()!
        return SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct PromptWidgetEntryView: View {
    var randomGratitudeQuestion: String = gratitudeQuestions.randomElement()!
    var randomGratitudeQuestion2: String = gratitudeQuestions.randomElement()!
    var randomGratitudeQuestion3: String = gratitudeQuestions.randomElement()!

    var entry: Provider.Entry

    var body: some View {
        VStack {
            Button {} label: {
                Text(randomGratitudeQuestion)
            }

            Button {} label: {
                Text(randomGratitudeQuestion2)
            }
        }
    }
}

struct PromptWidget: Widget {
    let kind: String = "PromptWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PromptWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color.widgetBackground
                    }
                    .foregroundStyle(.black)
            } else {
                PromptWidgetEntryView(entry: entry)
                    .padding()
                    .background(
                        Color.widgetBackground
                    )
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PromptWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
