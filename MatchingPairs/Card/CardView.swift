//
//  CardView.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 29.10.2024.
//

import SwiftUI
import MatchingPairsThemes

struct CardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var cardViewModel: CardViewModel
    var handleCardTap: (CardViewModel) -> ()
    @State private var isAnimating = false
    @State private var flashcardRotation = 0.0
    @State private var contentRotation = 0.0
    var index: Int
    var body: some View {
        ZStack {
            if cardViewModel.showCard {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.selectedTheme.card_color.color)
                    .aspectRatio(1/1.5, contentMode: .fit)
                    .padding(2).accessibilityIdentifier("card_\(index)")
                Text(cardViewModel.isFlipped ? cardViewModel.card.symbol : themeManager.selectedTheme.card_symbol)
                    .font(.system(size: 20))
            }
        }
        .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            if !cardViewModel.isFlipped && !isAnimating {
                flipFlashcard()
            }
        }
        .onChange(of: cardViewModel.needsFlipBack){
            if cardViewModel.needsFlipBack {
                flipBack()
                cardViewModel.needsFlipBack = false
            }
        }
        .rotation3DEffect(.degrees(flashcardRotation), axis: (x: 0, y: 1, z: 0))
    }
    
    
    func flipFlashcard() {
        flipAnimation(setIsFlipped: true)
    }
    
    func flipBack() {
        flipAnimation(setIsFlipped: false)
    }
    
    func flipAnimation(setIsFlipped: Bool){
        if setIsFlipped {
            handleCardTap(cardViewModel)
        }
        isAnimating = true
        let animationTime = 0.5
        withAnimation(Animation.linear(duration: animationTime/2)) {
            flashcardRotation += setIsFlipped ? 90 : -90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime / 2) {
            contentRotation += setIsFlipped ? 180 : -180
            cardViewModel.isFlipped = setIsFlipped
            withAnimation(Animation.linear(duration: animationTime/2)) {
                flashcardRotation += setIsFlipped ? 90 : -90
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                isAnimating = false
            }
        }
    }
        
 
}

#Preview {
    CardView(cardViewModel: CardViewModel(card: Card(symbol: "🔴")), handleCardTap: CardListViewModel(numberOfPairs: 10, viewContext: DataManager.preview.container.viewContext, timerManager: TimerManager(startTime: 30)).handleCardTap, index: 0).environmentObject(ThemeManager())
}
