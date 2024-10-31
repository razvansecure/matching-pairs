//
//  ContentView.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 29.10.2024.
//

import SwiftUI
import MatchingPairsThemes

struct ContentView: View {
    @StateObject var themeManager = ThemeManager()
    @State private var numberOfPairs = 15.0

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Choose theme: ")
                    Picker("theme", selection: $themeManager.selectedTheme) {
                        ForEach(themeManager.themes, id: \.self) { theme in
                            Text(theme.title)
                        }
                    }
                }
                Slider(
                    value: $numberOfPairs,
                    in: 2...30,
                    step: 1
                )
                let intNumberOfPairs = Int(numberOfPairs)
                Text("Number of pairs: \(intNumberOfPairs)")
                HStack {
                    NavigationLink(destination: CardListView(numberOfPairs: intNumberOfPairs, viewContext: DataManager.shared.container.viewContext)
                        .environmentObject(self.themeManager)) {
                            Text("Play")
                                .padding(20)
                        }
                    NavigationLink(destination: LeaderboardView()
                        .environment(\.managedObjectContext, DataManager.shared.container.viewContext)) {
                            Text("Leaderboard")
                        }
                }
            }
            .navigationTitle("Matching Pairs")
            .navigationBarTitleDisplayMode(.large)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
