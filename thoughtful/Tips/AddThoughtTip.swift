//
//  AddThoughtTip.swift
//  Thoughtful
//
//  Created by Nabil Ridhwan on 16/6/24.
//

import Foundation
import TipKit

struct AddThoughtTip: Tip {
    var title: Text {
        Text("Add Thought")
    }
    
    var message: Text? {
        Text("Tap here to add a new Thought")
    }
}
