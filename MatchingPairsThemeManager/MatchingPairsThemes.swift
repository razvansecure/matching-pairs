//
//  MatchingPairsThemes.swift
//  MatchingPairsThemes
//
//  Created by Razvan Secure on 30.10.2024.
//

import Foundation
import SwiftUI

public struct CardColor: Decodable, Hashable {
    public let red: Double
    public let green: Double
    public let blue: Double
    
    public var color: Color {
        Color(red: red, green: green, blue: blue)
    }
}

public struct Theme: Decodable, Hashable {
    public let card_color: CardColor
    public let card_symbol: String
    public let symbols: [String]
    public let title: String
}

public class ThemeManager: ObservableObject {
    @Published public var selectedTheme: Theme
    @Published public var themes: [Theme]
    
    public init() {
        let defaultTheme = ThemeManager.getDefaultTheme()
        self.selectedTheme = defaultTheme
        self.themes = [defaultTheme]
        Task {
            await fetchThemes()
        }
    }
    
    func fetchThemes() async {
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let themes = try JSONDecoder().decode([Theme].self, from: data)
            DispatchQueue.main.async {
                self.themes.append(contentsOf: themes)
            }
        } catch {
            print("Failed to fetch themes: \(error)")
        }
    }
    
    static func getDefaultTheme() -> Theme {
        let cardColor = CardColor(red: 0.0, green: 1.0, blue: 1.0)
        let cardSymbol = "♠️"
        let symbols = ["🇹🇩", "🇧🇷", "🇨🇦", "🇨🇿"]
        let title = "Flags"
        return Theme(card_color: cardColor, card_symbol: cardSymbol, symbols: symbols, title: title)
    }
}
