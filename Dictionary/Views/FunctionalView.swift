//
//  FunctionalView.swift
//  EnglishWords
//
//  Created by Виталя on 13.12.2022.
//

import SwiftUI

struct FunctionalView: View {
    @Binding var showAddEditView: Bool
    @Binding var showNewWordView: Bool
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @State var deletionConfirmation = false
    @Binding var depictedView: MenuViewModel


    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    
    
    var body: some View {
        
        if depictedView == .showDictionaryView {
            
            VStack(alignment: .leading, spacing: 12) {
                
                
                // Кнопка додавання нового слова
                Button {
                    showNewWordView = true
                    showAddEditView = false
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
                        showAddEditView = false
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
                        showAddEditView = false
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
            
            
            .alert("Ви впевнені, що хочете повністю очистити словник?", isPresented: $deletionConfirmation, actions: {
                  Button("Відмінити", role: .cancel, action: {})

                  Button("Видалити", role: .destructive, action: {
                      showAddEditView = false
                      showDeleteButton = false
                      removeAllFromDictionary(words: words)
                  })
                }, message: {
                  Text("")
                })
            
        } else {
            
            VStack(alignment: .leading, spacing: 12) {
                
                // Кнопка видалення 1го слова
                Button {
                    showDeleteButton = true
                    showAddEditView = false
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
                    removeAllFromRepeat(words: words)
                    showAddEditView = false
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

struct FunctionalView_Previews: PreviewProvider {
    static var previews: some View {
        return FunctionalView(showAddEditView: .constant(false),
                              showNewWordView: .constant(false),
                              showDeleteButton: .constant(false),
                              showAddToRepeatButton: .constant(false),
                              depictedView: .constant(.showDictionaryView))
        .background(.black)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        
        
    }
}


