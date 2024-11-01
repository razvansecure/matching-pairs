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
    @Published var score = 0
    @Published var isFinished = false
    var numberOfPairs: Int
    var timerManager: TimerManager
    
    init(numberOfPairs: Int, viewContext: NSManagedObjectContext, timerManager: TimerManager) {
        self.numberOfPairs = numberOfPairs
        self.viewContext = viewContext
        self.timerManager = timerManager
    }
    
    func resetGame(symbols: [String]) {
        flippedCard = nil
        isFinished = false
        matches = []
        timerManager.reset()
        score = 0
        cards = CardListViewModel.createCardList(numberOfPairs: numberOfPairs, symbols: symbols)
        timerManager.start()
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
        var cards: [CardViewModel] = []
        for i in 0..<numberOfPairs {
            let symbol = symbols[i % symbols.count]
            cards.append(CardViewModel(card: Card(symbol: symbol)))
            cards.append(CardViewModel(card: Card(symbol: symbol)))
        }
        return cards.shuffled()
    }
    
    func checkForMatch(firstCard: CardViewModel, secondCard: CardViewModel) {
        if firstCard.card.symbol == secondCard.card.symbol {
            matches.append(firstCard)
            matches.append(secondCard)
            score += numberOfPairs
            if matches.count == cards.count {
                endGame()
            }
            hideCards(firstCard: firstCard, secondCard: secondCard)
        } else {
            score -= numberOfPairs/4
            flipBackCards(firstCard: firstCard, secondCard: secondCard)
        }
    }
    
    func endGame() {
        score += numberOfPairs * timerManager.timeRemaining
        timerManager.stop()
        isFinished = true
        saveScore(score: score)
    }
    
    func hideCards(firstCard: CardViewModel, secondCard: CardViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            firstCard.showCard = false
            secondCard.showCard = false
        }
    }
    
    func flipBackCards(firstCard: CardViewModel, secondCard: CardViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            firstCard.needsFlipBack = true
            secondCard.needsFlipBack = true
        }
    }
    
    private func saveScore(score: Int) {
        let scoreTable = Score(context: viewContext)
        scoreTable.score = Int16(score)
        try? viewContext.save()
    }
}
