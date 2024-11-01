//
//  CardListViewModelTest.swift
//  MatchingPairsUITests
//
//  Created by Razvan Secure on 01.11.2024.
//

import XCTest
@testable import MatchingPairs

final class CardListViewModelTest: XCTestCase {
    
    var timerManager: TimerManager!
    var viewModel: CardListViewModel!

    override func setUpWithError() throws {
        timerManager = TimerManager(startTime: 100)
        viewModel = CardListViewModel(numberOfPairs: 30, viewContext: DataManager.preview.container.viewContext, timerManager: timerManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        timerManager = nil
    }

    func testInitialization() throws {
        XCTAssertEqual(viewModel.numberOfPairs, 30)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertFalse(viewModel.isFinished)
        XCTAssertNil(viewModel.flippedCard)
        XCTAssertEqual(viewModel.matches.count, 0)
        XCTAssertEqual(viewModel.cards.count, 0)
    }

    func testResetGame() {
        let symbols = ["1", "2", "3", "4"]
        viewModel.resetGame(symbols: symbols)

        XCTAssertEqual(viewModel.cards.count, 60)
        XCTAssertNil(viewModel.flippedCard)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertFalse(viewModel.isFinished)
        XCTAssertEqual(viewModel.matches.count, 0)
    }

    func testCheckForMatchTrue() {
        let symbols = ["1"]
        viewModel.resetGame(symbols: symbols)
        
        let firstCard = viewModel.cards[0]
        let secondCard = viewModel.cards[1]
        
        viewModel.checkForMatch(firstCard: firstCard, secondCard: secondCard)
        XCTAssertEqual(viewModel.matches.count, 2)
        XCTAssertEqual(viewModel.score, viewModel.numberOfPairs)
    }
    
    func testCheckForMatchFalse() {
        let symbols = Array(1...viewModel.numberOfPairs).map { "\($0)" }
        viewModel.resetGame(symbols: symbols)
        
        let firstCard = viewModel.cards[0]
        let secondCard = viewModel.cards[1]
        
        viewModel.checkForMatch(firstCard: firstCard, secondCard: secondCard)
        XCTAssertEqual(viewModel.matches.count, 0)
        let score = -viewModel.numberOfPairs / 4
        XCTAssertEqual(viewModel.score, score)
    }
    
    func testAllCardsMatch() {
        let symbols = ["1"]
        viewModel = CardListViewModel(numberOfPairs: 1, viewContext: DataManager.preview.container.viewContext, timerManager: timerManager)
        viewModel.resetGame(symbols: symbols)
        let firstCard = viewModel.cards[0]
        let secondCard = viewModel.cards[1]
        viewModel.checkForMatch(firstCard: firstCard, secondCard: secondCard)
        XCTAssertEqual(viewModel.matches.count, 2)
        let score = 1 + viewModel.timerManager.timeRemaining
        XCTAssertEqual(viewModel.score, score)
    }
    
    func testHandleCardTap() {
        XCTAssertNil(viewModel.flippedCard)
        let symbols = ["1"]
        viewModel.resetGame(symbols: symbols)
        let card1 = viewModel.cards[0]
        let card2 = viewModel.cards[1]
        viewModel.handleCardTap(card1)
        XCTAssertEqual(viewModel.flippedCard!.card, card1.card)
        viewModel.handleCardTap(card2)
        XCTAssertNil(viewModel.flippedCard)
    }
}
