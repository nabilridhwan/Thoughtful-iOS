//
//  AddEmotionTip.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 17/6/24.
//

import Foundation
import TipKit

struct AddEmotionTip: Tip {
    var title: Text {
        Text("Add Emotion")
    }

    var message: Text? {
        Text("Tap here to add an Emotion")
    }

    var image: Image? {
        Image(systemName: "smiley")
    }
}
