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
    @FocusState private var fieldInFocus: OnboardingField?
    
    var body: some View {
        ZStack {
            VStack {
                AddingNewWordDesignView(english: $english,
                                        ukrainian: $ukrainian,
                                        newWordsAdded: $newWordsAdded,
                                        showNewWordView: $showNewWordView)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 50)
            .cornerRadius(50)
            .ignoresSafeArea()
        }
        .background(.white.opacity(0.001))
        .onSubmit {
            switch fieldInFocus {
            case .englishFieldInFocus:
                fieldInFocus = .ukranianFieldInFocus
            default:
                if !ukrainian.isEmpty && !english.isEmpty {
                    save()
                } else {
                    print("Text field is empty.")
                }
            }
        }
    }
    
    func save() {
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
}


//MARK: - Canvas
struct AddingNewWordView_Previews: PreviewProvider {
    static var previews: some View {
        AddingNewWordView(showNewWordView: .constant(false))
    }
}


//MARK: - AddingNewWordView
struct AddingNewWordDesignView: View {
    
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
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                    
                    Button {
                        if !ukrainian.isEmpty && !english.isEmpty {
                            save()
                        } else {
                            print("Text field is empty.")
                        }
                        focusedField = .englishFieldInFocus
                        
                    } label: {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 40))
                    }
                }
                .padding(.top, 6)
                
                Spacer()
                
                // TextField 1
                VStack(alignment: .leading, spacing: 3) {
                    Text("Слово англійською".uppercased())
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(Color("color3"))
                    
                    TextField("", text: $english)
                        .foregroundColor(.black)
                        .focused($focusedField, equals: .englishFieldInFocus)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .font(.system(.body, design: .rounded))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("color3"), lineWidth: 2)
                                .padding(.vertical, 5)
                        )
                }
                .padding(.horizontal, 6)
                
                // TextField 2
                VStack(alignment: .leading, spacing: 3) {
                    Text("Переклад українською".uppercased())
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(Color("color3"))
                    
                    TextField("", text: $ukrainian)
                        .foregroundColor(.black)
                        .focused($focusedField, equals: .ukranianFieldInFocus)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .font(.system(.body, design: .rounded))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("color3"), lineWidth: 2)
                                .padding(.vertical, 5)
                        )
                }
                .padding(.horizontal, 6)
                
            }
            .padding(.bottom, 6)
            .padding(.horizontal, 6)
            .frame(height: 230)
            .background(Color("color2"))
            
            // Додані слова
            if newWordsAdded.isEmpty {
                Text("З моменту останнього запуску Ви ще не додали жодного нового слова.")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 6)
            } else {
                VStack {
                    HStack {
                        Text("Додані слова:")
                        Spacer()
                    }
                    .padding(.horizontal, 6)
                    
                    HStack {
                        Text("\(arrayConversion(newWordsAdded))")
                        Spacer()
                    }
                    .padding(.bottom, 12)
                    .padding(.horizontal, 6)
                }
            }
        }
        .background(Color("color3"))
        .cornerRadius(20)
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
            text += "\(word), "
        }
        return text
    }
}

