//
//  ThoughtCardAttributeView.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 13/6/24.
//

import SwiftUI

struct ThoughtCardAttrbuteView: View {
    
    let icon: String;
    let text: String;
    let backgroundColor: Color?
    let foregroundColor: Color?
    
    let shadowColor: Color?

    init(icon: String, text: String, backgroundColor: Color? = .cardAttribute, foregroundColor: Color? = .white.opacity(0.5), shadowColor: Color? = .clear) {
        self.icon = icon
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.shadowColor = shadowColor
    }

    var body: some View {
        Button{
            print("Attribute Clicked")
        } label:{
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
                .lineLimit(1)
        }
        .foregroundStyle(foregroundColor ?? .primary.opacity(0.5))
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
        .background{
            RoundedRectangle(cornerRadius: 9)
                .foregroundStyle(backgroundColor ?? .cardAttribute)
        }
        .shadow(color: (shadowColor!).opacity(0.3), radius: 5)
    }
}

#Preview {
    ThoughtCardAttrbuteView(icon: "smiley.fill", text: "Happy", backgroundColor: .yellow, foregroundColor: .black.opacity(0.6), shadowColor: .yellow)
}
