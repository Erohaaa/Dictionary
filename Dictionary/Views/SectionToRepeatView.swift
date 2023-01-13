//
//  RepeatWordsView.swift
//  Dictionary
//
//  Created by Виталя on 08.12.2022.
//

import SwiftUI

struct SectionToRepeatView: View {
    
    @State var showFunctionalView = false
    @State var showDeleteButton = false
    @State var deletionConfirmation = false
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    @Environment(\.managedObjectContext) var context
    
    var wordsInRepeat: Bool {
        var count = false
        for word in words {
            if word.inRepetition {
                count = true
            }
        }
        return count
    }
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    if wordsInRepeat {
                        ScrollView(showsIndicators: false) {
                            ForEach(words, id: \.self) { word in
                                if word.inRepetition {
                                    DesignListForSectionToRepeatView(showDeleteButton: $showDeleteButton, word: word)
                                }
                            }
                        }
                        .padding(.top)
                    } else {
                        SectionToRepeatViewEmpty()
                    }
                }
                .navigationTitle("Повторення слів")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if wordsInRepeat {
                            if showDeleteButton {
                                Button(action: {
                                    showDeleteButton = false
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
                    }
                }
                .accentColor(Color("Black&White"))
            }
            
            if showFunctionalView {
                FunctionalSectionToRepeatView(showFunctionalView: $showFunctionalView,
                                           showDeleteButton: $showDeleteButton,
                                           deletionConfirmation: $deletionConfirmation)
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0), value: showFunctionalView)
        
        .alert("Ви впевнені, що хочете повністю очистити розділ повторення?",
               isPresented: $deletionConfirmation,
               actions: {
            Button("Відмінити", role: .cancel, action: {})
            
            Button("Видалити", role: .destructive, action: {
                showFunctionalView = false
                showDeleteButton = false
                removeAllFromRepeat(words: words)
                
            })},
               message: { Text("") }
        )
    }
    private func removeAllFromRepeat(words: FetchedResults<Word>) {
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
struct RepeatingWordsView_Previews: PreviewProvider {
    static var previews: some View {
        SectionToRepeatView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//MARK: - DesignForSectionToRepeatView
struct DesignListForSectionToRepeatView: View {
    @Environment(\.managedObjectContext) var context
    @State var seeTranslation = false
    @Binding var showDeleteButton: Bool
    var word: Word
    
    var body: some View {
        HStack(spacing: 4) {
            ZStack {
                Color(seeTranslation ? "Blue" : "Olive")
                    .frame(height: 80)
                    .cornerRadius(10)
                
                
                Text(seeTranslation ? word.ukrainian : word.english)
                    .padding(.horizontal, 12)
                    .font(.system(size: 40))
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .rotation3DEffect(Angle(degrees: seeTranslation ? 180 : 0), axis: (x: 10, y: 0, z: 0))
            }
            .rotation3DEffect(Angle(degrees: (seeTranslation ? 180 : 0)), axis: (x: 10, y: 0, z: 0))
            .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0), value: seeTranslation)
            .onTapGesture {
                if !showDeleteButton {
                    seeTranslation.toggle()
                }
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
                .frame(width: 50, height: 82)
                .foregroundColor(.white)
                .background(Color("Delete button"))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal, 24)
    }
}


//MARK: - SectionToRepeatViewEmpty
struct SectionToRepeatViewEmpty: View {
    var body: some View {
        VStack {
            Text("Ви ще не додали жодного слова в розділ повторення, для цього виконайте послідовно такі дії:")
                .font(.system(size: 30))
                .foregroundColor(Color("Black&White"))
                .multilineTextAlignment(.center)
            HStack {
                Image(systemName: "text.book.closed.fill")
                
                Text("+")
                    .foregroundColor(.black)
                
                Image(systemName: "chevron.down")
                
                Text("+")
                    .foregroundColor(.black)
                
                Image("repeat")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            .foregroundColor(.white)
            .font(.system(size: 50))
            .minimumScaleFactor(0.3)
            .padding(6)
            .background(Color("Olive"))
            .cornerRadius(10)
        }
        .padding()
    }
}

//MARK: - FunctionalSectionToRepeatView
struct FunctionalSectionToRepeatView: View {
    @Binding var showFunctionalView: Bool
    @Binding var showDeleteButton: Bool
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
                    showDeleteButton = true
                    showFunctionalView = false
                } label: {
                    HStack {
                        Text("Видалити вибірково")
                        Spacer()
                        Image("orangetrash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                
                Button {
                    showFunctionalView = false
                    deletionConfirmation = true
                } label: {
                    HStack {
                        Text("Видалити всі слова")
                        Spacer()
                        Image("redtrash")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .foregroundColor(.red)
                
            }
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
            .font(.system(size: 20))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .background(Color("Olive for functional view"))
            .cornerRadius(10)
            .frame(width: 240)
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.horizontal, 16)
            .padding(.top, 40)
        }
    }
}
