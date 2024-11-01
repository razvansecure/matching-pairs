//
//  Card.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 29.10.2024.
//

import Foundation
import SwiftUICore

class Card: Identifiable, Equatable {
    var id = UUID()
    var symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
