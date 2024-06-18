//
//  CustomTabBarView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 18/6/24.
//

import SwiftUI

struct CustomTabBarView: View {
    var body: some View {
        HStack {
            Button {} label: {
                Label("Home", systemImage: "house")
                    .labelStyle(.iconOnly)
            }
            .frame(maxWidth: .infinity)

            Button {} label: {
                Label("Search", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
            }

            .frame(maxWidth: .infinity)

            Button {} label: {
                Label("Add", systemImage: "plus")
                    .font(.title)
                    .labelStyle(.iconOnly)
                    .padding(26)
                    .background {
                        Circle()
                            .foregroundStyle(.accent)
                    }
            }
            .shadow(color: .accent, radius: 20)
            .offset(y: -20)
            .frame(maxWidth: .infinity)

            Button {} label: {
                Label("Calendar", systemImage: "calendar")
                    .labelStyle(.iconOnly)
            }

            .frame(maxWidth: .infinity)

            Button {} label: {
                Label("Settings", systemImage: "gear")
                    .labelStyle(.iconOnly)
            }

            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .foregroundStyle(.white)
        .background {
            Rectangle()
                .background(.card)
        }
    }
}

#Preview {
    CustomTabBarView()
        .previewLayout(.sizeThatFits)
}
