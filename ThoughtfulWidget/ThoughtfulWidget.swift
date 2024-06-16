//
//  ThoughtfulWidget.swift
//  ThoughtfulWidget
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @State var person: String = "3";
    
    func placeholder(in context: Context) -> ThoughtfulWidgetEntry {
        ThoughtfulWidgetEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ThoughtfulWidgetEntry) -> ()) {
        let entry = ThoughtfulWidgetEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entries: [ThoughtfulWidgetEntry] = [ThoughtfulWidgetEntry(date: currentDate)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ThoughtfulWidgetEntry: TimelineEntry {
    var date: Date
}

struct ThoughtfulWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.black)
            
            Text("Add Thought")
                .font(.headline)
                .bold()
            Text("Be grateful for today!")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                
                Text("Today's thoughts")
                    .font(.caption2)
                    .bold()
                
                Spacer()
                
                Text("3")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .bold()
            }
        }
        .widgetURL(URL(string: "thoughtful://add"))
    }
}

struct ThoughtfulWidget: Widget {
    let kind: String = "ThoughtfulWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ThoughtfulWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget){
                        LinearGradient(gradient: Gradient(colors: [.accent, .accent.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                        
                    }
                    .foregroundStyle(.black)
            } else {
                ThoughtfulWidgetEntryView(entry: entry)
                    .padding()
                    .background(.accent)
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
