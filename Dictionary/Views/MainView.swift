//  MainView.swift
//  Dictionary

//  Created by Виталя on 10.01.2023.

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            DictionaryView()
                .tabItem {
                    Label("Словник", systemImage: "text.book.closed.fill")
                }
                .tag(0)
            
            SectionToRepeatView()
                .tabItem {
                    Label("Повторення", systemImage: "repeat")
                }
                .tag(1)
        }
        .accentColor(Color("Olive"))
    }
}


//MARK: - Canves
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        MainView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
