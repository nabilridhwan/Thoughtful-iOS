//
//  NoThoughtsView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct EmptyThoughtsView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Uh-ooh. We found no Thoughts", systemImage: "tray.fill")
        } description: {
            Text("Add Thoughts and they'll appear here.")
        }
    }
}

#Preview {
    EmptyThoughtsView()
}
