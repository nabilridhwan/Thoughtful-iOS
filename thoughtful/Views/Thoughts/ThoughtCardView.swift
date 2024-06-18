//
//  ThoughtCardView.swift
//  thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

var dateFormatter = DateFormatter()

struct ThoughtCardView: View {
    let thought: Thought

    var cardColor: Color {
        thought.emotionExists ? thought.emotion!.getColor().opacity(0.1) : .card
    }

    var dateLabel: String {
        thought.date_created.formatted(.relative(presentation: .named))
    }

    @State var photo: UIImage? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if photo != nil {
                Image(uiImage: photo!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .transition(.scale.combined(with: .opacity))
            }

            Text(thought.thought_prompt)
                .fontWeight(.bold)
                .font(.headline)
                .opacity(0.5)

            Text(LocalizedStringKey(thought.thought_response))
                .font(.callout)
                .lineLimit(2)
                .opacity(0.9)

            HStack {
                if thought.locationExists || thought.musicExists || thought.emotionExists {
                    if thought.locationExists {
                        ThoughtCardAttrbuteView(icon: Image(systemName: "location.fill"), text: "Eunos")
                    }

                    if thought.musicExists {
                        ThoughtCardAttrbuteView(icon: Image(systemName: "music.note"), text: "The Backseat Lovers - Pool House")
                    }

                    if thought.emotionExists {
                        ThoughtCardAttrbuteView(icon: Image(thought.emotion!.getIcon()), text: thought.emotion!.description.capitalized, backgroundColor: thought.emotion!.getColor(), foregroundColor: .black.opacity(0.6), shadowColor: thought.emotion!.getColor())
                            .transition(
                                .scale.combined(with: .opacity)
                            )
                    }
                }

                Spacer()
            }
            .padding(.vertical, 2)
            .padding(.top, 8)

            VStack(alignment: .trailing) {
                Text(dateLabel.localizedCapitalized)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .task {
            DispatchQueue.global().async {
                if !thought.photos.isEmpty, let loadedPhoto = UIImage(data: thought.photos[0]) {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.photo = loadedPhoto
                        }
                    }
                }
            }
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.primary)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(cardColor)
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ThoughtCardView(thought: Thought(thought_prompt: "What are three things that I am grateful for?", thought_response: "My Friends, **Nazrul** for _checking up on me_, The movie night on Discord. I am gonna write a longer thought just to see if the lines would concatenate beacuse to be honest. This can get very long!", date_created: Date.now, location: "Eunos", music: "The Backseat Lovers - Pool House", emotion: .terrible))
}
