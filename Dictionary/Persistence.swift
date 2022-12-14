//
//  Persistence.swift
//  EnglishWords
//
//  Created by Виталя on 21.11.2022.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Word")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let word = Word(context: viewContext)
        word.english = "Strawberry"
        word.ukrainian = "Полуниця"
        word.timestamp = Date()
        word.inRepetition = true
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var testData: [Word]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Word]
    }()
}
