//
//  NoThoughtsView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct EmptyThoughtsView: View {
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "face.smiling")
                .resizable(resizingMode: .stretch)
                .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 50, height: 50)
            
            Text("Uh oh, we found zero thoughts!")
                .font(.title3)
                .bold()
            Text("Get started by writing your first thought. Just press the \'Add Thought\' button above!")
                .foregroundStyle(.white.opacity(0.5))
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.white.opacity(0.8))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyThoughtsView()
}
