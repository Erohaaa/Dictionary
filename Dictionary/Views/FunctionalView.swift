//
//  FunctionalView.swift
//  Dictionary
//
//  Created by Виталя on 13.12.2022.
//

import SwiftUI

struct FunctionalView: View {
    @Binding var deletionConfirmation: Bool
    @Binding var showFunctionalView: Bool
    @Binding var showNewWordView: Bool
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @Binding var depictedView: MenuViewModel
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        
        ZStack {
            Color.white.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    showFunctionalView = false
                }
            
            
            if depictedView == .showDictionaryView {
                FunctionalForDictionaryView(words: _words,
                                            showFunctionalView: $showFunctionalView,
                                            showNewWordView: $showNewWordView,
                                            showDeleteButton: $showDeleteButton,
                                            showAddToRepeatButton: $showAddToRepeatButton,
                                            deletionConfirmation: $deletionConfirmation)
                
            } else {
                FunctionalForRepeatingView(words: _words,
                                           showFunctionalView: $showFunctionalView, deletionConfirmation: $deletionConfirmation,
                                           showDeleteButton: $showDeleteButton,
                                           showAddToRepeatButton: $showAddToRepeatButton)
                
            }
        }
    }
}


//MARK: - Canvas
struct FunctionalView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionalView(deletionConfirmation: .constant(false),
                       showFunctionalView: .constant(false),
                       showNewWordView: .constant(false),
                       showDeleteButton: .constant(false),
                       showAddToRepeatButton: .constant(false),
                       depictedView: .constant(.showDictionaryView))
        .background(.black)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        FunctionalView(deletionConfirmation: .constant(false),
                       showFunctionalView: .constant(false),
                       showNewWordView: .constant(false),
                       showDeleteButton: .constant(false),
                       showAddToRepeatButton: .constant(false),
                       depictedView: .constant(.showRepeatWordView))
        .background(.black)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//MARK: - FunctionalForDictionaryView
struct FunctionalForDictionaryView: View {
    @FetchRequest var words: FetchedResults<Word>
    @Binding var showFunctionalView: Bool
    @Binding var showNewWordView: Bool
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @Binding var deletionConfirmation: Bool
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Кнопка додавання нового слова
            Button {
                showNewWordView = true
                showFunctionalView = false
            } label: {
                HStack {
                    Text("Додати нові слова")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Image("plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            
            if !words.isEmpty {
                // Кнопка додавання в повторення
                Button {
                    showAddToRepeatButton = true
                    showFunctionalView = false
                } label: {
                    HStack {
                        Text("Додати в повторення")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Image("repeat2")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
                // Кнопка видалення 1го слова
                Button {
                    showDeleteButton = true
                    showFunctionalView = false
                } label: {
                    HStack {
                        Text("Видалити вибірково")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Image("orangetrash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
                // Кнопка видалення всіх слів
                Button {
                    deletionConfirmation = true
                } label: {
                    HStack {
                        Text("Видалити всі слова")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                        
                        Image("redtrash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .foregroundColor(.red)
                
            }
        }
        .font(.system(size: 20))
        .padding(6)
        .background(.white)
        .cornerRadius(10)
        .frame(width: 240)
        .foregroundColor(.black)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
        .padding(.horizontal, 16)
        .padding(.top, 40)
    }
}
    
    

//MARK: - FunctionalForRepeatingView
struct FunctionalForRepeatingView: View {
    @FetchRequest var words: FetchedResults<Word>
    @Binding var showFunctionalView: Bool
    @Binding var deletionConfirmation: Bool
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Кнопка видалення 1го слова
            Button {
                showDeleteButton = true
                showFunctionalView = false
            } label: {
                HStack {
                    Text("Видалити вибірково")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Image("orangetrash")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            
            // Кнопка видалення всіх слів з повторення
            Button {
                showFunctionalView = false
                deletionConfirmation = true
            } label: {
                HStack {
                    Text("Видалити всі слова")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Image("redtrash")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            .foregroundColor(.red)
            
        }
        .font(.system(size: 20))
        .padding(6)
        .background(.white)
        .cornerRadius(10)
        .frame(width: 240)
        .foregroundColor(.black)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
        .padding(.horizontal, 16)
        .padding(.top, 40)
    }
}

