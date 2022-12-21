//
//  ArrayWordsView.swift
//  Dictionary
//
//  Created by Виталя on 21.11.2022.
//

import SwiftUI
import AVFoundation

struct DictionaryView: View {
    
    let synthesizer = AVSpeechSynthesizer()
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @Binding var showFunctionalView: Bool
    @Binding var showMenuView: Bool
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("color1")
                    .ignoresSafeArea()
                if words.isEmpty {
                    ifDictionaryIsEmpty()
                    
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(words.indices, id: \.self) { index in
                            DictionaryListDesignView(synthesizer: synthesizer, word: words[index], showDeleteButton: $showDeleteButton, showAddToRepeatButton: $showAddToRepeatButton)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Словник")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showDeleteButton || showAddToRepeatButton {
                        Button(action: {
                            showDeleteButton = false
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showMenuView = true
                        showFunctionalView = false
                        showDeleteButton = false
                        showAddToRepeatButton = false
                        
                    } label: {
                        Image(systemName: "text.justify")
                    }
                }
                
            }
            .accentColor(.white)
        }
    }
}


//MARK: - Canvas
struct ArrayWordsView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView(showDeleteButton: .constant(false),
                       showAddToRepeatButton: .constant(true),
                       showFunctionalView: .constant(false),
                       showMenuView: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//MARK: - DictionaryListDesign
struct DictionaryListDesignView: View {
    var synthesizer: AVSpeechSynthesizer
    @ObservedObject var word: Word
    @Binding var showDeleteButton: Bool
    @Binding var showAddToRepeatButton: Bool
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        HStack(spacing: -2) {
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
            .background(Color("color3"))
            .cornerRadius(20, corners: [.topLeft, .bottomLeft])
            
            Spacer()
            
            VStack(alignment: .center) {
                Text(word.english)
                    .frame(width: 230)
                    .foregroundColor(.black)
                    .font(.system(size: 40))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                
                Text(word.ukrainian)
                    .frame(width: 230)
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.5)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("color2"))
            .cornerRadius(showDeleteButton || showAddToRepeatButton ? 0 : 20, corners: [.topRight, .bottomRight])
            
            Spacer()
            
            if showDeleteButton {
                Button {
                    withAnimation {
                        context.delete(word)
                        do {
                            try context.save()
                        } catch {
                            print("Error (delete)")
                        }
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: .infinity)
                .background(Color("color5"))
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            }
            
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
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: .infinity)
                .background(word.inRepetition ? Color("color6") : Color("color2"))
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            }
        }
        .animation(.linear(duration: 0.2))
    }
}

//MARK: - ifDictionaryIsEmpty
struct ifDictionaryIsEmpty: View {
    var body: some View {
        VStack {
            HStack {
                Text("Щоб додати слова")
                    .font(.system(size: 25))
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
                
                Image("finger")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
            }
            Spacer()
        }
        .padding(.top, 20)
    }
}


