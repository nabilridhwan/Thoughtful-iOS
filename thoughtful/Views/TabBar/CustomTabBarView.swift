//
//  CustomTabBarView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 18/6/24.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    @Binding var showAddModal: Bool

    @Namespace var capsuleNs;

    var body: some View {
        HStack {
            VStack {
                Button {
                    withAnimation {
                        selectedTab = 0
                    }
                } label: {
                    Label("Home", systemImage: "house")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.white.opacity(selectedTab == 0 ? 1 : 0.5))
                .frame(maxWidth: .infinity)

                if selectedTab == 0 {
                    Capsule()
                        .frame(width: 18, height: 6)
                        .offset(y: 10)
                        .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                }
            }

            VStack {
                Button {
                    withAnimation {
                        selectedTab = 1
                    }
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.white.opacity(selectedTab == 1 ? 1 : 0.5))
                .frame(maxWidth: .infinity)

                if selectedTab == 1 {
                    Capsule()
                        .frame(width: 18, height: 6)
                        .offset(y: 10)
                        .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                }
            }

            Button {
                showAddModal = true
            } label: {
                Label("Add", systemImage: "plus")
                    .font(.title2)
                    .labelStyle(.iconOnly)
                    .padding(26)
                    .background {
                        LinearGradient(colors: [.gradient1, .gradient2], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                            .clipShape(Circle())
                    }
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity)

            VStack {
                Button {
                    withAnimation {
                        selectedTab = 3
                    }
                } label: {
                    Label("Calendar", systemImage: "calendar")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.white.opacity(selectedTab == 3 ? 1 : 0.5))
                .frame(maxWidth: .infinity)

                if selectedTab == 3 {
                    Capsule()
                        .frame(width: 18, height: 6)
                        .offset(y: 10)
                        .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                }
            }

            VStack {
                Button {
                    withAnimation {
                        selectedTab = 4
                    }
                } label: {
                    Label("Settings", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
                .foregroundStyle(.white.opacity(selectedTab == 4 ? 1 : 0.5))
                .frame(maxWidth: .infinity)
                if selectedTab == 4 {
                    Capsule()
                        .frame(width: 18, height: 6)
                        .offset(y: 10)
                        .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                }
            }
        }
        .font(.custom("Custom Tab Bar Icon", size: 18))
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .foregroundStyle(.primary)
        .background {
            Rectangle()
                .foregroundStyle(.card)
        }
    }
}

#Preview {
    CustomTabBarView(
        selectedTab: .constant(1),
        showAddModal: .constant(false)
    )
    .previewLayout(.sizeThatFits)
}
