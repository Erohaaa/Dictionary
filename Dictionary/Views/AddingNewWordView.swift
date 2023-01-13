//
//  NewWordView.swift
//  Dictionary
//
//  Created by Виталя on 21.11.2022.
//

import SwiftUI

struct AddingNewWordView: View {
    @State var english = ""
    @State var ukrainian = ""
    @State var newWordsAdded: [String] = []
    @Binding var showNewWordView: Bool
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.0001)
                .onTapGesture {
                    showNewWordView = false
                }
            
            VStack {
                DesignAddingNewWordView(english: $english,
                                        ukrainian: $ukrainian,
                                        newWordsAdded: $newWordsAdded,
                                        showNewWordView: $showNewWordView)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}


//MARK: - Canvas
struct AddingNewWordView_Previews: PreviewProvider {
    static var previews: some View {
        AddingNewWordView(showNewWordView: .constant(false))
        
        AddingNewWordView(showNewWordView: .constant(false))
            .preferredColorScheme(.dark)
    }
}


//MARK: - DesignAddingNewWordView
struct DesignAddingNewWordView: View {
    
    @Binding var english: String
    @Binding var ukrainian: String
    @Binding var newWordsAdded: [String]
    @Binding var showNewWordView: Bool
    @Environment(\.managedObjectContext) var context
    @FocusState var focusedField: OnboardingField?
    
    
    var body: some View {
        VStack {
            VStack {
                
                // Кнопки
                HStack(alignment: .top) {
                    Button {
                        self.showNewWordView.toggle()
                        focusedField = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color("Black&White"))
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                    
                    Button {
                        if !ukrainian.isEmpty && !english.isEmpty {
                            save()
                        }
                        focusedField = .englishFieldInFocus
                        
                    } label: {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color("Black&White"))
                            .font(.system(size: 40))
                    }
                }
                .padding(.top, 6)
                
                Spacer()
                
                // TextField 1
                VStack(alignment: .leading, spacing: 3) {
                    Text(String(localized: "ENGLISH WORD"))
                        .font(.system(.headline, design: .rounded))
                    
                    TextField("", text: $english)
                        .foregroundColor(Color("Black&White"))
                        .focused($focusedField, equals: .englishFieldInFocus)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .font(.system(.body, design: .rounded))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("Black&White"), lineWidth: 2)
                                .padding(.vertical, 5)
                        )
                }
                .padding(.horizontal, 6)
                
                // TextField 2
                VStack(alignment: .leading, spacing: 3) {
                    Text(String(localized: "TRANSLATION"))
                        .font(.system(.headline, design: .rounded))
                    
                    TextField("", text: $ukrainian)
                        .foregroundColor(Color("Black&White"))
                        .focused($focusedField, equals: .ukranianFieldInFocus)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .font(.system(.body, design: .rounded))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("Black&White"), lineWidth: 2)
                                .padding(.vertical, 5)
                        )
                }
                .padding(.horizontal, 6)
                
            }
            .padding(.bottom, 6)
            .padding(.horizontal, 6)
            .frame(height: 230)
            .background(Color("White&Black").opacity(0.7))
            
            // Додані слова
            
            
            if newWordsAdded.isEmpty {
                Text("You haven't added any new words since the last run.")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 6)
                
            } else {
                VStack(spacing: 6) {
                    HStack {
                        Text("Added words:")
                        Spacer()
                    }
                    
                    ScrollView {
                        HStack {
                            Text("\(arrayConversion(newWordsAdded))")
                            Spacer()
                        }
                    }
                    .padding(3)
                    .background(.black.opacity(0.08))
                    .frame(maxHeight: 70)
                    .cornerRadius(5)
                }
                .padding(.bottom, 12)
                .padding(.horizontal, 12)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Black&White"), lineWidth: 2)
                .padding(1)
        )
        .background(Color("Olive"))
        .cornerRadius(20)
        .onChange(of: showNewWordView, perform: { _ in
            focusedField = nil
        })
        .onSubmit {
            if !showNewWordView {
                focusedField = nil
            } else {
                switch focusedField {
                case .englishFieldInFocus:
                    focusedField = .ukranianFieldInFocus
                default:
                    if !ukrainian.isEmpty && !english.isEmpty {
                        save()
                        focusedField = .englishFieldInFocus
                        
                    }
                }
            }
        }
    }
    
    
    private func save() {
        let word = Word(context: context)
        word.english = english
        word.ukrainian = ukrainian
        word.timestamp = Date()
        word.inRepetition = false
        do {
            try context.save()
            newWordsAdded.append(english)
            english = ""
            ukrainian = ""
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
    
    func arrayConversion(_ arrayString: [String]) -> String {
        var text = ""
        for word in arrayString {
            if !text.isEmpty {
                text = "\(word), " + text
            } else {
                text = "\(word). " + text
                
            }
        }
        return text
    }
}

