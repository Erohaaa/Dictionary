//
//  RepeatWordsView.swift
//  Dictionary
//
//  Created by Виталя on 08.12.2022.
//

import SwiftUI

struct RepeatingWordsView: View {
    
    var wordsInRepeat: Bool {
        var count = false
        for word in words {
            if word.inRepetition {
                count = true
            }
        }
        return count
    }
    
    @Binding var showMenuView: Bool
    @Binding var showFunctionalView: Bool
    @Binding var showDeleteButton: Bool
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.timestamp, order: .reverse)
        ])
    var words: FetchedResults<Word>
    
        
    var body: some View {
        NavigationView {
            ZStack {
                Color("color3")
                    .ignoresSafeArea()
                
                if wordsInRepeat {
                    ScrollView(showsIndicators: false) {
                        ForEach(words, id: \.self) { word in
                            if word.inRepetition {
                                RepeatingWordsViewDesignView(showDeleteButton: $showDeleteButton, word: word)
                            }
                        }
                    }
                    .padding(.top)
                    
                } else {
                    RepeatingWordsViewIsEmpty()
                }
            }
            .navigationTitle("Повторення слів")
            .navigationBarTitleDisplayMode(.inline)
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showMenuView = true
                        showFunctionalView = false
                        showDeleteButton = false
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
struct RepeatWordsView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatingWordsView(showMenuView: .constant(false), showFunctionalView: .constant(false), showDeleteButton: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}


//MARK: - DesignRepeatWordsView
struct RepeatingWordsViewDesignView: View {
    @Environment(\.managedObjectContext) var context
    @State var seeTranslation = false
    @Binding var showDeleteButton: Bool
    var word: Word
    
    var body: some View {
        HStack(spacing: 1) {
            ZStack {
                ZStack {
                    Color(seeTranslation ? "color1" : "color2")
                        .frame(height: 80)
                        .blur(radius: 5, opaque: true)
                    Color.white
                        .opacity(0.2)
                        .background(.black.opacity(0.2))
                        .frame(height: 80)
                }
                .overlay {
                    Rectangle()
                        .stroke(Color(.black), lineWidth: 2)
                }
                
                Text(seeTranslation ? word.ukrainian : word.english)
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    .frame(width: 188)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .rotation3DEffect(Angle(degrees: seeTranslation ? 180 : 0), axis: (x: 10, y: 0, z: 0))
            }
            .rotation3DEffect(Angle(degrees: (seeTranslation ? 180 : 0)), axis: (x: 10, y: 0, z: 0))
            .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0))
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
                .background(Color("color5"))
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            }
        }
        .padding(.horizontal, 24)
    }
}

//MARK: - RepeatingWordsViewIsEmpty
struct RepeatingWordsViewIsEmpty: View {
    var body: some View {
        VStack {
            Text("Ви ще не додали жодного слова в розділ повторення, для цього виконайте послідовно такі дії:")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            HStack {
                Image(systemName: "text.justify")
                    .font(.system(size: 45))
                
                Text("+")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                
                
                Image("dictionary")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("+")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 50))
                
                Text("+")
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                
                Image("repeat")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                
            }
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .foregroundColor(.white)
            .padding(6)
            .background(Color("color1"))
            .cornerRadius(10)
        }
        .padding()
    }
}
