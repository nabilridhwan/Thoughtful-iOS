//
//  SettingsView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import SwiftUI

enum Day: String, CaseIterable {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = ""

    @AppStorage("decolorizeCards") private var decolorizeCards: Bool = false

    @AppStorage("hideImagesInCard") private var hideImagesInCard: Bool = false

    @AppStorage("enableRecap") private var enableRecap: Bool = true

    @AppStorage("remindersEnabled") private var remindersEnabled: Bool = false

    @State private var selectedDays: [Day] = []
    @State private var time: Date = .now

    func displayReminderString() -> String {
        if selectedDays.count == 0 {
            return ""
        }

        let days = selectedDays.map { $0.rawValue.capitalized }

        let formattedDays: String
        if days.count == 7 {
            formattedDays = "every day"
        } else if days.count == 1 {
            formattedDays = "every \(days.first!)"
        } else {
            let lastDay = days.last!
            let otherDays = days.dropLast().joined(separator: ", ")
            formattedDays = "every \(otherDays) and \(lastDay)"
        }

        return "We'll remind you at \(time.formatted(date: .omitted, time: .shortened)) \(formattedDays)."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title)
                .bold()
                .padding()

            List {
                VStack(alignment: .center, spacing: 10) {
                    Image(.logoPremium)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)

                    Text("Thoughtful Premium")
                        .font(.title2)
                        .bold()

                    Text("A single in-app purchase that unlocks features such as reminders, iCloud integration, Recap, and more...")

                        .opacity(0.6)
                        .multilineTextAlignment(.center)

                    Text("Coming Soon")
                        .font(.caption)
                        .opacity(0.5)

                    //                Button("Find out more"){
                    //
                    //                }
                }
                .shadow(color: .logoBackground.opacity(0.5), radius: 30)
                .frame(maxWidth: .infinity)
                .padding()
                .listRowBackground(RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.logoBorder))

                Section(header: Text("Name")) {
                    VStack(alignment: .leading) {
                        TextField("Name", text: $userName)
                            .help("Enable to display cards in grayscale, turning off emotional color cues.")
                        Text("We use this name to greet you! Try replacing it with \"good looking 😉\"")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

//                Section(header: Text("[Upcoming] Features")){
//                    VStack(alignment: .leading){
//
//                        Toggle("Recap", isOn: $enableRecap)
//                            .help("Recap will remind you everyday to look back on your Thoughts from yesterday. To remind you to be grateful!")
//                            .disabled(true)
//                        Text("Recap will remind you everyday to look back on your Thoughts from yesterday. To remind you to be grateful!")
//                            .font(.caption)
//                            .foregroundStyle(.secondary)
//                    }
//                }

                Section(header: Text("Customization")) {
                    VStack(alignment: .leading) {
                        Toggle("Emotion Card Decolorization", isOn: $decolorizeCards)
                            .help("Enable to display cards in grayscale, turning off emotional color cues.")
                        Text("Enable to display cards in grayscale, turning off emotional color cues.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Toggle("Hide images in card", isOn: $hideImagesInCard)
                            .help("Enable to hide images in card, showing only text content")
                        Text("Enable to hide images in card, showing only text content")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section(header: Text("Open Source Attributions")) {
                    Text("MingCute Icons")
                    Text("CalendarView")
                    Text("HorizonCalendar")
                }

                Section(header: Text("Support")) {
                    Link(destination: URL(string: "mailto:nabridhwan@gmail.com")!
                    ) {
                        Label("Email", systemImage: "envelope.fill")
                    }

                    Link(destination: URL(string: "https://www.nabilridhwan.com")!
                    ) {
                        Label("Website", systemImage: "globe")
                    }
                }

                //            Section(header: Text("Reminders"), footer: Text(displayReminderString())) {
                //                Toggle("Enable Reminders", isOn: $remindersEnabled)
                //
                //                if isRemindersEnabled {
                //                    HStack(alignment: .center) {
                //                        ForEach(Day.allCases, id: \.self) { day in
                //                            Text(String(day.rawValue.first!))
                //                                .bold()
                //                                .foregroundStyle(.primary)
                //                                .frame(width: 30, height: 30)
                //                                .background(selectedDays.contains(day) ? Color.cyan.cornerRadius(10) : Color.gray.cornerRadius(10))
                //                                .onTapGesture {
                //                                    withAnimation {
                //                                        if selectedDays.contains(day) {
                //                                            selectedDays.removeAll(where: { $0 == day })
                //                                        } else {
                //                                            selectedDays.append(day)
                //                                        }
                //                                    }
                //                                }
                //                        }
                //                    }
                //
                //                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                //                        .onAppear {
                //                            UIDatePicker.appearance().minuteInterval = 15
                //                        }
                //                }
                //            }

//                Add empty spacer at the bottom without list background
                Rectangle()
                    .frame(height: 80)
                    .opacity(0)
                    .listRowBackground(Rectangle().opacity(0))
            }
            //            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //        .padding()
        .foregroundStyle(.primary)
        .background(Color.background)
    }
}

#Preview {
    SettingsView()
}
