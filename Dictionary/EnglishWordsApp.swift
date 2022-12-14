//
//  EnglishWordsApp.swift
//  EnglishWords
//
//  Created by Виталя on 21.11.2022.
//

import SwiftUI

@main
struct EnglishWordsApp: App {
    
    let persistenceController = PersistenceController.shared

    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
