//
//  DictionaryView2.swift
//  Dictionary
//
//  Created by Виталя on 10.01.2023.
//

import SwiftUI
import AVFoundation

struct DictionaryView: View {
    
    let synthesizer = AVSpeechSynthesizer()
    let screen = UIScreen.main.bounds
    
    @State private var searchText = ""
    @State var showFunctionalView = false
    @State var showNewWordView = false
    @State var showAddToRepeatButton = false
    @State var deletionConfirmation = false
    
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(words.indices, id: \.self) { index in
                        DesignListDictionaryView(synthesizer: synthesizer,
                                                 word: words[index],
                                                 showAddToRepeatButton: $showAddToRepeatButton)
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                    
                }
                .padding(.vertical, 6)
                .buttonStyle(BorderlessButtonStyle())
                .listStyle(.plain)
                .navigationTitle("Dictionary")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            
                            if !words.isEmpty {
                                if showAddToRepeatButton {
                                    Button(action: {
                                        showAddToRepeatButton = false
                                    }) {
                                        Image(systemName: "xmark")
                                    }
                                } else {
                                    Button(action: {
                                        showFunctionalView.toggle()
                                    }) {
                                        Image(systemName: showFunctionalView ? "chevron.up" : "chevron.down")
                                    }
                                }
                            }
                            
                            Button(action: {
                                showNewWordView = true
                                showAddToRepeatButton = false
                                showFunctionalView = false
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .accentColor(Color("Black&White"))
            }
            .blur(radius: showNewWordView ? 10 : 0, opaque: true)
            .ignoresSafeArea()
            
            
            if showFunctionalView {
                FunctionalForDictionaryView(showFunctionalView: $showFunctionalView,
                                            showAddToRepeatButton: $showAddToRepeatButton,
                                            deletionConfirmation: $deletionConfirmation)
            }
            
            AddingNewWordView(showNewWordView: $showNewWordView)
                .offset(y: showNewWordView ? 0 : -screen.height)
                .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0), value: showNewWordView)
            
        }
        .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0), value: showFunctionalView)
        
        .alert("Are you sure you want to delete all words?",
               isPresented: $deletionConfirmation,
               actions: {
            Button("Cancel", role: .cancel, action: {})
            
            Button("DELETE", role: .destructive, action: {
                showFunctionalView = false
                
                removeAllFromDictionary(words: words)
                
            })},
               message: { Text("") }
        )
        
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Seatch word(s)...")
        
        .onChange(of: searchText) { searchText in
            let predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "english CONTAINS[c] %@ OR ukrainian CONTAINS[c] %@", searchText, searchText)
            words.nsPredicate = predicate
        }
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = words[index]
            context.delete(itemToDelete)
        }
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func removeAllFromDictionary(words: FetchedResults<Word>) {
        for word in words {
            context.delete(word)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}


//MARK: - Canvas
struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        DictionaryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}


//MARK: - DictionaryListDesignView
struct DesignListDictionaryView: View {
    
    var synthesizer: AVSpeechSynthesizer
    @ObservedObject var word: Word
    @Binding var showAddToRepeatButton: Bool
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        HStack(spacing: -2) {
            
            // Кнопка відтворення слова
            Button {
                let utterance = AVSpeechUtterance(string: word.english)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                synthesizer.speak(utterance)
            } label: {
                Image(systemName: "speaker.wave.2")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: .infinity)
            .background(Color("Olive"))
            .cornerRadius(20, corners: [.topLeft, .bottomLeft])
            
            Spacer()
            
            // Текст
            VStack(alignment: .center) {
                Text(word.english)
                    .frame(width: 230)
                    .foregroundColor(Color("Black&White"))
                    .font(.system(size: 40))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                
                Text(word.ukrainian)
                    .frame(width: 230)
                    .foregroundColor(Color("Black&White").opacity(0.7))
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("Olive2"))
            .cornerRadius(showAddToRepeatButton ? 0 : 20, corners: [.topRight, .bottomRight])
            
            Spacer()
            
            // Кнопка додавання в повторення
            if showAddToRepeatButton {
                Button {
                    word.inRepetition.toggle()
                    do {
                        try context.save()
                    } catch {
                        print("error 50")
                    }
                } label: {
                    Image(systemName: word.inRepetition ? "checkmark" : "plus.circle")
                        .foregroundColor(Color("Black&White"))
                        .font(.system(size: 30))
                }
                .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: .infinity)
                .background(word.inRepetition ? Color("Checkmark") : Color("Olive2"))
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            }
        }
        .animation(.easeOut, value: showAddToRepeatButton)
    }
}


//MARK: - FunctionalForDictionaryView
struct FunctionalForDictionaryView: View {
    @Binding var showFunctionalView: Bool
    @Binding var showAddToRepeatButton: Bool
    @Binding var deletionConfirmation: Bool
    
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.0001)
                .ignoresSafeArea()
                .onTapGesture {
                    showFunctionalView = false
                }
            
            // Кнопки
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    showAddToRepeatButton = true
                    showFunctionalView = false
                } label: {
                    HStack {
                        Text("Add to repeat")
                        Spacer()
                        Image("repeat")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
                Button {
                    deletionConfirmation = true
                } label: {
                    HStack {
                        Text("Delete all words")
                            .foregroundColor(.red)
                        Spacer()
                        Image("redtrash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
            .font(.system(size: 20))
            .background(Color("Olive for functional view"))
            .cornerRadius(10)
            .frame(width: 240)
            .foregroundColor(.black)
            .padding(.horizontal, 50)
            .padding(.top, 40)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
}
