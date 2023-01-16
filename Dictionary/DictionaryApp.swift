//
//  EnglishWordsApp.swift
//  Dictionary
//
//  Created by Виталя on 21.11.2022.
//

import SwiftUI

@main
struct Dictionary: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (phase) in
            switch phase {
            case .active:
                print("Active")
            case .inactive:
                print("Inactive")
            case .background:
                createQuickActions()
            @unknown default:
                print("Default scene phase")
            }
        }
    }
    
    final class MainSceneDelegate: UIResponder, UIWindowSceneDelegate {
        
        @Environment(\.openURL) private var openURL: OpenURLAction
        
        // Метод для запуску швидких дій.
        func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
            completionHandler(handleQuickAction(shortcutItem: shortcutItem))
        }
        
        private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
            let shortcutType = shortcutItem.type
            
            guard let shortcutIdentifier = shortcutType.components(separatedBy: ".").last else {
                return false
            }
            
            guard let url = URL(string: "dictionaryapp://actions/" + shortcutIdentifier) else {
                print("Failed to initiate the url")
                return false
            }
            openURL(url)
            return true
        }
        
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let shortcutItem = connectionOptions.shortcutItem else {
                return
            }
            handleQuickAction(shortcutItem: shortcutItem)
        }
    }
    
    final class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let configuration = UISceneConfiguration(name: "Main Scene", sessionRole: connectingSceneSession.role)
            configuration.delegateClass = MainSceneDelegate.self
            return configuration
        }
    }
    
    func createQuickActions() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewWord",
                                                          localizedTitle: String(localized: "Add new word(s)"),
                                                          localizedSubtitle : nil,
                                                          icon: UIApplicationShortcutIcon(systemImageName: "plus"),
                                                          userInfo: nil)
            
            let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenRepeating",
                                                          localizedTitle: String(localized: "Open repeating"),
                                                          localizedSubtitle: nil,
                                                          icon: UIApplicationShortcutIcon(systemImageName: "repeat"),
                                                          userInfo: nil)
            

            
            UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2]
        }
    }
    
}

