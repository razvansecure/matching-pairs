//
//  Card.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 29.10.2024.
//

import SwiftUI
import MatchingPairsThemes
import CoreData

struct CardListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: CardListViewModel
    @State var lostScreen = false
    
    init(numberOfPairs: Int, viewContext: NSManagedObjectContext) {
        self.viewModel = CardListViewModel(numberOfPairs: numberOfPairs, viewContext: viewContext)
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Score: \(viewModel.score)")
                    HStack {
                        Text("Time remaining: ")
                        Text("\(viewModel.timeRemaining)s")
                            .onReceive(viewModel.timer) { _ in
                                if viewModel.timeRemaining > 0 {
                                    viewModel.timeRemaining -= 1
                                }
                                else {
                                    lostScreen = true
                                }
                            }
                            .frame(alignment: .leading)
     
                    }
                }.padding()
            }
            
            GeometryReader { geometry in
                if geometry.size != .zero {
                    let columns = calculateGridLayout(geometry: geometry, cardCount: viewModel.cards.count)
                    VStack {
                        if lostScreen {
                            Text("You lost!")
                                .font(.system(size: 50))
                        }
                        else if viewModel.isFinished {
                            Text("You won!")
                                .font(.system(size: 50))
                        }
                        else {
                            LazyVGrid(columns: columns, spacing: 0) {
                                ForEach(viewModel.cards){ card in
                                    CardView(cardViewModel: card, handleCardTap: viewModel.handleCardTap)
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            Button(action: {
                viewModel.resetGame(symbols: themeManager.selectedTheme.symbols)
                self.lostScreen = false
            }) {
                Text("Reset")
            }
            .padding()
        }
        .onAppear {
            viewModel.resetGame(symbols: themeManager.selectedTheme.symbols)
        }
    }
    
    private func calculateGridLayout(geometry: GeometryProxy, cardCount: Int) -> [GridItem] {
        
        let gridWidth = geometry.size.width
        let gridHeight = geometry.size.height
        let numberOfCards = CGFloat(cardCount)
        let nrColumns = floor((numberOfCards * gridWidth / (gridHeight / 1.5)).squareRoot())
        let rows = ceil(numberOfCards / nrColumns)
        let cardWidth = min(gridWidth / nrColumns, gridHeight / (rows * 1.5))
        let columns = Array(repeating: GridItem(.fixed(cardWidth), spacing: 0), count: Int(nrColumns))
        return (columns)
    }
    
    
}

#Preview {
    CardListView(numberOfPairs: 50,viewContext: DataManager.preview.container.viewContext).environmentObject(ThemeManager())
}
