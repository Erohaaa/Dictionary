//
//  MainView.swift
//  EnglishWords
//
//  Created by Виталя on 13.12.2022.
//

import SwiftUI

struct MainView: View {
    
    @State var showNewWordView = false
    @State var showAddEditView = false
    @State var showDeleteButton = false
    @State var showAddToRepeatButton = false
    @State var showMenuView = false
    @State var depictedView: MenuViewModel = .showDictionaryView
    
    var body: some View {
        ZStack {
            if depictedView == .showDictionaryView {
                DictionaryView(showDeleteButton: $showDeleteButton, showAddToRepeatButton: $showAddToRepeatButton, showAddEditView: $showAddEditView, showMenuView: $showMenuView)
                    .blur(radius: showNewWordView ? 8 : 0, opaque: true)
                    .blur(radius: showMenuView ? 8 : 0, opaque: true)
                    .ignoresSafeArea()
            } else {
                RepeatWordsView(showMenuView: $showMenuView, showEditView: $showAddEditView, showDeleteButton: $showDeleteButton)
                    .blur(radius: showNewWordView ? 8 : 0, opaque: true)
                    .blur(radius: showMenuView ? 8 : 0, opaque: true)
                    .ignoresSafeArea()
            }

            
            if showAddEditView {
                FunctionalView(showAddEditView: $showAddEditView, showNewWordView: $showNewWordView, showDeleteButton: $showDeleteButton, showAddToRepeatButton: $showAddToRepeatButton, depictedView: $depictedView)
            }
            
            MenuView(showMenuView: $showMenuView, depictedView: $depictedView)
                .offset(x: showMenuView ? -0 : -screen.height)
                .animation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0))
            
            NewWordView(showNewWordView: $showNewWordView)
                .offset(y: showNewWordView ? -0 : -screen.height)
                .animation(.spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0))
            
            
        }
        

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)


    }
}

