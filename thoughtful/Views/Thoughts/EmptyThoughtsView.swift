//
//  EmptyThoughtsView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct EmptyThoughtsView: View {
    var body: some View {
        ContentUnavailableView {
            Label {
                Text("No Thoughts?")
            } icon: {
                Image(.logo)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        } description: {
            Text("Looks like your mind is clear! Jot down your thoughts while they're fresh. Remember, you can't go back in time!")
        }
    }
}

#Preview {
    EmptyThoughtsView()
}
