//
//  ChooseEmotionView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ChooseEmotionView: View {
    @Binding var emotion: Emotion?
    @Environment(\.dismiss) var dismiss;

    func handleAddEmotion(_ e: Emotion) {
        withAnimation {
            //        If the incoming emotion is the same as the emotion selected, then it means the user is trying to deselect, hence set emotion to nil
            if emotion == e {
                emotion = nil
                return
            }
            //        set the emotion 'binding' to the value passed
            emotion = e
        }
    }

    // Function to define the grid layout
    private func gridLayout() -> [GridItem] {
        var gridItems = [GridItem]()
        for _ in 0 ..< 3 {
            gridItems.append(GridItem(.flexible(), spacing: 16))
        }
        return gridItems
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("How are you feeling?")
                .font(.title)
                .bold()

            ScrollView {
                LazyVGrid(columns: gridLayout()) {
                    ForEach(Emotion.allCases, id: \.self) {
                        e in
                        Button {
                            handleAddEmotion(e)
                            dismiss()
                        } label: {
                            VStack {
                                Image(e.getIconNoFace())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)

                                Text(e.description.capitalized)

                                //                        if e == emotion {
                                //                            Label(e.description.capitalized, systemImage: "checkmark")
                                //                        } else {
                                //                            Image(.sad)
                                //                                .resizable()
                                //                                .foregroundStyle(.black)
                                //                                .frame(width: 20, height: 20)
                                //                            Label(e.description, image: .sad)

                                //                            Text(e.description.capitalized)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black.opacity(0.7))
                        .background(e.getColor(), in: RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    ChooseEmotionView(emotion: .constant(nil))
}
