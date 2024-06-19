//
//  ThoughtDetailView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 15/6/24.
//

import SwiftUI

struct ThoughtDetailView: View {
    @ObservedObject var thought: Thought
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    //    State for showing the confirm delete option
    @State var isPresentingConfirm: Bool = false
    @State var isPresentingEdit: Bool = false

    var emotionExists: Bool {
        thought.emotion != nil
    }

    var relativeDateCreated: String {
        thought.date_created.formatted(.relative(presentation: .named)).capitalized
    }

    @State var photo: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if photo != nil {
                    Image(uiImage: photo!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(
                            .scale.combined(with: .opacity)
                        )
                }

                Text(thought.thought_prompt)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(LocalizedStringKey(thought.thought_response))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                //            https://developer.apple.com/documentation/foundation/date/relativeformatstyle

                if emotionExists {
                    Text("Emotion")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.5))
                    ThoughtCardAttrbuteView(icon: Image(thought.emotion!.getIcon()), text: thought.emotion!.description.capitalized, backgroundColor: thought.emotion!.getColor(), foregroundColor: .black.opacity(0.6), shadowColor: thought.emotion!.getColor())
                } else {
                    Text("How were you feeling?")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    HStack {
                        ForEach(Emotion.allCases, id: \.self) {
                            e in

                            Button {
                                withAnimation {
                                    thought.emotion = e
                                }
                            } label: {
                                VStack {
                                    Image(e.getIcon())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(e.getColor())
                                }
                            }
                            .padding()
                            .background(e.getColor(), in: RoundedRectangle(cornerRadius: 14)
                                .stroke(lineWidth: 2))

                            //                            ThoughtCardAttrbuteView(icon: Image(e.getIcon()), text: e.description.capitalized, backgroundColor: e.getColor(), foregroundColor: .black.opacity(0.6), shadowColor: e.getColor())
                        }
                    }
                }

                Text("Created")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Label(relativeDateCreated, systemImage: "clock")
                    .foregroundStyle(.secondary.opacity(0.7))
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .foregroundStyle(.primary)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    isPresentingEdit = true
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Delete", role: .destructive) {
                    isPresentingConfirm = true

                }.foregroundStyle(.red)
            }
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
        .sheet(isPresented: $isPresentingEdit) {
            AddNewThoughtView(thought: thought, date: .constant(Date.now))
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
            Button("Delete", role: .destructive) {
                dismiss()
                context.delete(thought)
            }
        } message: {
            Text("Are you sure? You cannot undo this action")
        }
    }
}

#Preview {
    NavigationStack {
        ThoughtDetailView(thought: SampleData.shared.thought)
    }
    .modelContext(SampleData.shared.context)
    .modelContainer(SampleData.shared.modelContainer)
}

#Preview {
    NavigationStack {
        ThoughtDetailView(thought: .init(thought_prompt: "Prompt", thought_response: "Response", date_created: Date.now))
    }
    .modelContext(SampleData.shared.context)
    .modelContainer(SampleData.shared.modelContainer)
}
