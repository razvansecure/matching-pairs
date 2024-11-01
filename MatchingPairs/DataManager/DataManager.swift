//
//  DataManager.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 30.10.2024.
//

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject {    
    static let shared = DataManager()
    
    @MainActor
    static let preview: DataManager = {
        let result = DataManager(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 1..<10 {
            let newItem = Score(context: viewContext)
            newItem.score = Int16(i)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
