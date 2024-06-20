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

    //    State for animating the add button in
    @State var showAddButton: Bool = false

    @Namespace var capsuleNs;

    let addThoughtTip = AddThoughtTip()

    var body: some View {
        ZStack(alignment: .bottom) {
            //            Rectangle()
            //                .frame(height: 200)
            LinearGradient(colors: [.background.opacity(0), .background.opacity(1)], startPoint: .top, endPoint: .bottom)
                .offset(y: -40)
                .frame(height: 140)

            HStack {
                VStack {
                    Button {
                        withAnimation {
                            selectedTab = 0
                        }
                    } label: {
                        Label("Home", systemImage: "house.fill")
                            .labelStyle(.iconOnly)
                    }
                    .foregroundStyle(.primary.opacity(selectedTab == 0 ? 1 : 0.5))
                    .frame(maxWidth: .infinity)

                    if selectedTab == 0 {
                        Capsule()
                            .frame(width: 18, height: 6)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                    }
                }

                //                VStack {
                //                    Button {
                //                        withAnimation {
                //                            selectedTab = 1
                //                        }
                //                    } label: {
                //                        Label("Stats", systemImage: "chart.pie.fill")
                //                            .labelStyle(.iconOnly)
                //                    }
                //                    .foregroundStyle(.primary.opacity(selectedTab == 1 ? 1 : 0.5))
                //                    .frame(maxWidth: .infinity)
                //
                //                    if selectedTab == 1 {
                //                        Capsule()
                //                            .frame(width: 18, height: 6)
                //                            .offset(y: 10)
                //                            .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                //                    }
                //                }

                if showAddButton {
                    Button {
                        showAddModal = true
                        addThoughtTip.invalidate(reason: .actionPerformed)
                    } label: {
                        Label("Add", systemImage: "plus")
                            .font(.title2)
                            .labelStyle(.iconOnly)
                            .padding(30)
                            .foregroundStyle(.white)
                            .background {
                                LinearGradient(colors: [.gradient1, .gradient2], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                                    .clipShape(Circle())
                            }
                    }
                    .offset(y: -20)
                    .frame(maxWidth: .infinity)
                    .popoverTip(addThoughtTip)
                    .transition(.push(from: .bottom).combined(with: .scale))
                }

                //                VStack {
                //                    Button {
                //                        withAnimation {
                //                            selectedTab = 3
                //                        }
                //                    } label: {
                //                        Label("Calendar", systemImage: "calendar")
                //                            .labelStyle(.iconOnly)
                //                    }
                //                    .foregroundStyle(.primary.opacity(selectedTab == 3 ? 1 : 0.5))
                //                    .frame(maxWidth: .infinity)
                //
                //                    if selectedTab == 3 {
                //                        Capsule()
                //                            .frame(width: 18, height: 6)
                //                            .offset(y: 10)
                //                            .matchedGeometryEffect(id: "navcapsule", in: capsuleNs)
                //                    }
                //                }

                VStack {
                    Button {
                        withAnimation {
                            selectedTab = 4
                        }
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.iconOnly)
                    }
                    .foregroundStyle(.primary.opacity(selectedTab == 4 ? 1 : 0.5))
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
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity, maxHeight: 90)
            .foregroundStyle(.primary)
            .background {
                Rectangle()
                    .foregroundStyle(.card)
            }
            .onAppear {
                withAnimation {
                    showAddButton = true
                }
            }
        }
    }
}

#Preview {
    CustomTabBarView(
        selectedTab: .constant(0),
        showAddModal: .constant(false)
    )
    .previewLayout(.sizeThatFits)
}
