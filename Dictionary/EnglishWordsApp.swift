//
//  EnglishWordsApp.swift
//  Dictionary
//
//  Created by Виталя on 21.11.2022.
//

import SwiftUI

@main
struct EnglishWordsApp: App {
    
    let persistenceController = PersistenceController.shared

    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color(.white))]
        navBarAppearance.backgroundColor = UIColor(named: "NavigationBarColor")
        navBarAppearance.backgroundEffect = .none
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
