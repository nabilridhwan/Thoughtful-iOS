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
        return SimpleEntry(date: Date())
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date.now),
        ]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

func getUrlWithEmotion(_ emotion: Emotion) -> URL {
    return URL(
        string: "thoughtful://add?prompt=Share what it is that makes you feel this way, in this moment&emotion=\(emotion.rawValue)"
    )!
}

struct PromptWidgetEntryView: View {
    var randomGratitudeQuestion: String = gratitudeQuestions.randomElement()!
    var randomGratitudeQuestion2: String = gratitudeQuestions.randomElement()!
    var randomGratitudeQuestion3: String = gratitudeQuestions.randomElement()!

    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Emotion Check-In")
                .font(.headline)
                .bold()

            Text("Select an emotion to express and reflect on your current mood")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(Emotion.allCases, id: \.self) {
                    e in
                    Link(destination: getUrlWithEmotion(e),
                         label: {
                             Label {
                                 Text(e.rawValue)
                             } icon: {
                                 Image(e.getIcon())
                                     .resizable()
                                     .frame(width: 30, height: 30)
                             }.labelStyle(.iconOnly)
                                 .padding(10)
                                 .foregroundStyle(.black.opacity(0.6))
                                 .background(e.getColor(), in: RoundedRectangle(cornerRadius: 10))
                         })
                }

            }.foregroundStyle(.primary)
                .multilineTextAlignment(.center)
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
                        Color.card
                    }
            } else {
                PromptWidgetEntryView(entry: entry)
                    .padding()
                    .background(
                        Color.card
                    )
            }
        }
        .configurationDisplayName("Mood Check")
        .description("Tap to log your current mood with our emotion buttons")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    PromptWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
