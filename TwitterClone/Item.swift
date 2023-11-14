//
//  Item.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 14/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
