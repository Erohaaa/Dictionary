//
//  MainView.swift
//  Dictionary
//
//  Created by Виталя on 13.12.2022.
//

import SwiftUI

struct MainView: View {
    
    let screen = UIScreen.main.bounds
    @State var deletionConfirmation = false
    @State var showMenuView = false
    @State var showFunctionalView = false
    @State var showNewWordView = false
    @State var showDeleteButton = false
    @State var showAddToRepeatButton = false
    @State var depictedView: MenuViewModel = .showDictionaryView
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        ZStack {
            if depictedView == .showDictionaryView {
                DictionaryView(showDeleteButton: $showDeleteButton, showAddToRepeatButton: $showAddToRepeatButton, showFunctionalView: $showFunctionalView, showMenuView: $showMenuView)
                    .blur(radius: showNewWordView ? 8 : 0, opaque: true)
                    .blur(radius: showMenuView ? 8 : 0, opaque: true)
                    .ignoresSafeArea()
            } else {
                RepeatingWordsView(showMenuView: $showMenuView, showFunctionalView: $showFunctionalView, showDeleteButton: $showDeleteButton)
                    .blur(radius: showNewWordView ? 8 : 0, opaque: true)
                    .blur(radius: showMenuView ? 8 : 0, opaque: true)
                    .ignoresSafeArea()
            }
            
            if showFunctionalView {
                FunctionalView(deletionConfirmation: $deletionConfirmation, showFunctionalView: $showFunctionalView, showNewWordView: $showNewWordView, showDeleteButton: $showDeleteButton, showAddToRepeatButton: $showAddToRepeatButton, depictedView: $depictedView)
            }
            
            MenuView(showMenuView: $showMenuView, depictedView: $depictedView)
                .offset(x: showMenuView ? -0 : -screen.height)
                .animation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0))
            
            AddingNewWordView(showNewWordView: $showNewWordView)
                .offset(y: showNewWordView ? -0 : -screen.height)
                .animation(.spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0))
        }
        .alert(depictedView == .showDictionaryView ? "Ви впевнені, що хочете повністю очистити словник?" : "Ви впевнені, що хочете повністю очистити розділ повторення?",
               isPresented: $deletionConfirmation,
               actions: {
            Button("Відмінити", role: .cancel, action: {})
            Button("Видалити", role: .destructive, action: {
                showFunctionalView = false
                showDeleteButton = false
                if depictedView == .showDictionaryView {
                    removeAllFromDictionary(words: words)

                } else {
                    removeAllFromRepeat(words: words)
                }
                })
        },
               message: { Text("") }
        )
    }
    func removeAllFromDictionary(words: FetchedResults<Word>) {
        for word in words {
            context.delete(word)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func removeAllFromRepeat(words: FetchedResults<Word>) {
        for word in words {
            word.inRepetition = false
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}


//MARK: - Canvas
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}

