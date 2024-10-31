//
//  CardListViewController.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 29.10.2024.
//

import Foundation
import MatchingPairsThemes
import SwiftUICore
import CoreData

class CardListViewModel: ObservableObject {
    var viewContext: NSManagedObjectContext
    @Published var flippedCard: CardViewModel?
    @Published var matches = [CardViewModel]()
    @Published var cards: [CardViewModel] = []
    @Published var timeRemaining: Int
    @Published var score = 0
    @Published var isFinished = false
    var numberOfPairs: Int
    let startTimeRemaining = 15
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(numberOfPairs: Int, viewContext: NSManagedObjectContext) {
        self.numberOfPairs = numberOfPairs
        self.timeRemaining = startTimeRemaining
        self.viewContext = viewContext
    }
    
    func resetGame(symbols: [String]) {
        flippedCard = nil
        isFinished = false
        matches = []
        timeRemaining = startTimeRemaining
        score = 0
        cards = CardListViewModel.createCardList(numberOfPairs: numberOfPairs, symbols: symbols)
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    
    func handleCardTap(_ card: CardViewModel) {
        if let firstCard = flippedCard {
            checkForMatch(firstCard: firstCard, secondCard: card)
            flippedCard = nil
        } else {
            flippedCard = card
        }
    }

    
    static func createCardList(numberOfPairs: Int, symbols: [String]) -> [CardViewModel] {
        //let symbols = ["🔴", "🔵", "🟠", "🟡", "🟢", "🟣"]
        var cards: [CardViewModel] = []
        for i in 0..<numberOfPairs {
            let symbol = symbols[i % symbols.count]
            cards.append(CardViewModel(card: Card(symbol: symbol)))
            cards.append(CardViewModel(card: Card(symbol: symbol)))
        }
        return cards.shuffled()
    }
    
    private func checkForMatch(firstCard: CardViewModel, secondCard: CardViewModel) {
        if firstCard.card.symbol == secondCard.card.symbol {
            matches.append(firstCard)
            matches.append(secondCard)
            score += numberOfPairs
            if matches.count == cards.count {
                score += numberOfPairs * timeRemaining
                timer.upstream.connect().cancel()
                isFinished = true
                saveScore(score: score)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                firstCard.showCard = false
                secondCard.showCard = false
            }
        } else {
            score -= numberOfPairs/4
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                firstCard.needsFlipBack = true
                secondCard.needsFlipBack = true
            }
        }
    }
    
    private func saveScore(score: Int) {
        let scoreTable = Score(context: viewContext)
        scoreTable.score = Int16(score)
        try? viewContext.save()
    }
    
    private func addScore() {
        score += numberOfPairs
    }
}
