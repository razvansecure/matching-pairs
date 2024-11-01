//
//  LeaderboardView.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 30.10.2024.
//

import SwiftUI
import CoreData

struct LeaderboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var fetchRequest: FetchRequest<Score>
    
    init() {
        let request: NSFetchRequest<Score> = Score.fetchRequest()
        request.fetchLimit = 20
        request.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        fetchRequest = FetchRequest<Score>(fetchRequest: request)
    }
    
    var body: some View {
        Text("Leaderboard")
            .bold()
        if fetchRequest.wrappedValue.isEmpty {
            Text("No scores saved")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        List {
            ForEach(Array(fetchRequest.wrappedValue.enumerated()), id: \.offset) { index, element in
                
                Text("\(index + 1). \(element.score)")
            }
        }
    }

}

#Preview {
    LeaderboardView()
}
