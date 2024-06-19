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
        Text("Add how you're feeling")
    }

    var message: Text? {
        Text("Tap here to tag how you're feeling")
    }
}
