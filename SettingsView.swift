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
    @State var name: String = ""
    @State var isRemindersEnabled: Bool = false

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
        VStack(alignment: .leading) {
            Text("Settings")
                .fontWeight(.bold)
                .font(.largeTitle)

            Form {
                Section(header: Text("About You")) {
                    TextField("Name", text: $name)
                }

                Section(header: Text("Reminders"), footer: Text(displayReminderString())) {
                    Toggle("Enable Reminders", isOn: $isRemindersEnabled)

                    if isRemindersEnabled {
                        HStack(alignment: .center) {
                            ForEach(Day.allCases, id: \.self) { day in
                                Text(String(day.rawValue.first!))
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(selectedDays.contains(day) ? Color.cyan.cornerRadius(10) : Color.gray.cornerRadius(10))
                                    .onTapGesture {
                                        withAnimation {
                                            if selectedDays.contains(day) {
                                                selectedDays.removeAll(where: { $0 == day })
                                            } else {
                                                selectedDays.append(day)
                                            }
                                        }
                                    }
                            }
                        }

                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                            .onAppear {
                                UIDatePicker.appearance().minuteInterval = 15
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
