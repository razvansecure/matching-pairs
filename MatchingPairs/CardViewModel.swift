//
//  CardViewModel.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 31.10.2024.
//

import Foundation

class CardViewModel: ObservableObject, Identifiable {
    let card: Card
    @Published var isFlipped = false
    @Published var showCard = true
    @Published var needsFlipBack = false
    
    init(card: Card) {
        self.card = card
    }
}
