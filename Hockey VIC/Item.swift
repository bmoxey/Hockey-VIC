//
//  Item.swift
//  Hockey VIC
//
//  Created by Brett Moxey on 14/11/2023.
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
