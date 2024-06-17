//
//  MainOnboardingView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 17/6/24.
//

import SwiftUI

struct MainOnboardingView: View {
    @Binding var doneOnboarding: Bool

    var body: some View {
        TabView {
            OnboardingWelcomeView()
            OnboardingNameView(
                doneOnboarding: $doneOnboarding
            )

            //            OnboardingRequestNotificationPermission(
            //                doneOnboarding: $doneOnboarding
            //            )
        }
        .padding()
        .background(Color.background)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .tabViewStyle(.page)
        .multilineTextAlignment(.center)
    }
}

struct OnboardingWelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
//            Image(.logo)
            Image(.onboardingIllustration)
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .foregroundStyle(.primary)

            VStack {
                Text("Welcome to")
                    .foregroundStyle(.secondary)

                Text("Thoughtful")
                    .font(.largeTitle)
                    .bold()
            }

            Text("In our fast-paced world, it's easy to overlook the beauty of life. With Thoughtful, we'll help you rediscover it, one step at a time.")
                .foregroundStyle(.secondary)

            //            Button{
            //            }label: {
            //                Text("Get Started")
            //            }
            //            .buttonStyle(.borderedProminent)
            //            .frame(maxWidth: .infinity)
            //            .padding(.vertical, 8)
            //            .foregroundStyle(.black)
            //            .background{
            //                RoundedRectangle(cornerRadius: 24)
            //                    .foregroundStyle(.tint)
            //            }
        }
    }
}

struct OnboardingNameView: View {
    @Binding var doneOnboarding: Bool
    @AppStorage("userName") private var userName = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("What's your name?")
                .font(.title)
                .bold()
            Text("We use your name for a more personalised touch!")
                .foregroundStyle(.secondary)

            TextField("Type your name here", text: $userName)

            Button {
                withAnimation {
                    doneOnboarding = true
                }

            } label: {
                Text("Continue")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.black)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.tint)
            }
        }
    }
}

struct ThoughtfulReminderConfiguration: Codable {
    var remindersEnabled: Bool = false
    var reminderTime: Date = .distantFuture
}

struct OnboardingRequestNotificationPermission: View {
    @Binding var doneOnboarding: Bool

    @AppStorage("remindersEnabled") private var remindersEnabled: Bool = false
    @State private var reminderTime: Date = .distantFuture

    var body: some View {
        VStack(spacing: 20) {
            Text("Stay Inspired Daily")
                .font(.title)
                .bold()
            Text("Enable daily reminders to keep your thoughts flowing.")
                .foregroundStyle(.secondary)

            Toggle("Enable Reminders", isOn: $remindersEnabled)

            if remindersEnabled {
                DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }

            Button {
                withAnimation {
                    doneOnboarding = true
                }

            } label: {
                Text("Continue")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.black)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.tint)
            }
        }
    }
}

// #Preview {
//    MainOnboardingView()
// }
