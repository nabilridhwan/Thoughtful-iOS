//
//  ThoughtfulWidget.swift
//  ThoughtfulWidget
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entries: [SimpleEntry] = [SimpleEntry(date: currentDate)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
}

struct ThoughtfulWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.tint)
            
            Text("Add Thought")
                .bold()
            Text("Be grateful for today!")
                .foregroundStyle(.secondary)
            
            //            Text(entry.date, style: .time)
            
            //            Text("Emoji:")
            //            Text(entry.emoji)
            
        }
        //            .widgetURL(URL(string: "com.nabilridhwan.thoughtful://add"))
        .widgetURL(URL(string: "thoughtful://add"))
    }
}

struct ThoughtfulWidget: Widget {
    let kind: String = "ThoughtfulWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ThoughtfulWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ThoughtfulWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Add Thought")
        .description("A widget to add thought from your home screen!")
    }
}

#Preview(as: .systemSmall) {
    ThoughtfulWidget()
} timeline: {
    SimpleEntry(date: .now)
}
