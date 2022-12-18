//
//  RepeatWordsView.swift
//  EnglishWords
//
//  Created by Виталя on 08.12.2022.
//

import SwiftUI

struct RepeatWordsView: View {
    
    var wordsInRepeat: Int {
        var count = 0
        for word in words {
            if word.inRepetition {
                count = 1
            }
        }
        return count
    }
    @Binding var showMenuView: Bool
    @Binding var showEditView: Bool
    @Binding var showDeleteButton: Bool
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    
        
    var body: some View {
        NavigationView {
            ZStack {
                Color("color1")
                    .ignoresSafeArea()
                
                if wordsInRepeat == 1 {
                    ScrollView(showsIndicators: false) {
                        ForEach(words, id: \.self) { word in
                            if word.inRepetition {
                                DesignRepeatWordsView(showDeleteButton: $showDeleteButton, word: word)
                            }
                        }
                    }
                    .padding(.top, 24)
                    
                } else {
                    Text("Розділ повторення пустий, перейдіть в Словник та додайте потрібні вам слова для повторення.")
                        .font(.system(size: 25))
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationTitle("Повторення слів")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if wordsInRepeat == 1 {
                        if showDeleteButton {
                            Button(action: {
                                showDeleteButton = false
                            }) {
                                Image(systemName: "xmark")
                            }
                            
                        } else {
                            
                            Button(action: {
                                showEditView.toggle()
                            }) {
                                Image(systemName: showEditView ? "chevron.up" : "chevron.down")
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showMenuView = true
                        showEditView = false
                        showDeleteButton = false
                    } label: {
                        Image(systemName: "text.justify")
                    }
                }
            }
            .accentColor(.white)
        }
        .shadow(radius: 20)
    }
    
}


//MARK: - Canvas
struct RepeatWordsView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatWordsView(showMenuView: .constant(false), showEditView: .constant(false), showDeleteButton: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}


//MARK: - DesignRepeatWordsView
struct DesignRepeatWordsView: View {
    @Environment(\.managedObjectContext) var context
    @State var seeTranslation = false
    @Binding var showDeleteButton: Bool
    var word: Word
    
    var body: some View {
        HStack {
            ZStack {
                ZStack {
                    Image(seeTranslation ? "ua" : "uk")
                        .resizable()
                        .frame(height: 100)
                        .blur(radius: 3, opaque: true)
                    Color.black
                        .opacity(0.5)
                        .background(.black.opacity(0.2))
                        .frame(height: 100)
                }
                .overlay {
                    Rectangle()
                        .stroke(Color(.white), lineWidth: 1)
                        .padding(1)
                }
                
                Text(seeTranslation ? word.ukrainian : word.english)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .frame(width: 188)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .rotation3DEffect(Angle(degrees: seeTranslation ? 180 : 0), axis: (x: 10, y: 0, z: 0))
            }
            .rotation3DEffect(Angle(degrees: (seeTranslation ? 180 : 0)), axis: (x: 10, y: 0, z: 0))
            .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0))
            .onTapGesture {
                seeTranslation.toggle()
            }
            
            if showDeleteButton {
                Button {
                    withAnimation {
                        word.inRepetition = false
                        do {
                            try context.save()
                        } catch {
                            print("Error (delete)")
                        }
                        
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 30))
                }
                .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: .infinity)
                .background(Color("color5"))
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            }
        }
        .padding(.top, 6)
        .padding(.horizontal, 24)
    }
}
