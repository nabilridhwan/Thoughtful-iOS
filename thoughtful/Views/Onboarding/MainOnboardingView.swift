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
            Image(.logo)
                .resizable(resizingMode: .stretch)
                .frame(width: 100, height: 100)
                .foregroundStyle(.primary)

            VStack {
                Text("Thoughtful")
                    .font(.largeTitle)
                    .bold()
            }

            Text("In our fast-paced world, it's easy to forget how great life is. Thoughtful will change that, one step at a time.")
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

// #Preview {
//    MainOnboardingView()
// }
