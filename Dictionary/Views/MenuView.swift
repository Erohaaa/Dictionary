//
//  MenuView.swift
//  EnglishWords
//
//  Created by Виталя on 12.12.2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var showMenuView: Bool
    @Binding var depictedView: MenuViewModel
    
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    showMenuView = false
                }
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Меню")
                        .padding(.horizontal, 6)
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    Color.black
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 2)
                }
                .padding(.top, 70)
                
                VStack {
                    Button {
                        depictedView = .showDictionaryView
                        showMenuView = false
                    } label: {
                        Image("dictionary")
                            .resizable()
                            .frame(width: 70, height: 70)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80)
                    .background(.black.opacity(depictedView == .showDictionaryView ? 0.3 : 0))
                    
                    Button {
                        depictedView = .showRepeatWordView
                        showMenuView = false
                    } label: {
                        Image("repeat")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80)
                    .background(.black.opacity(depictedView == .showRepeatWordView ? 0.3 : 0))
                }
                .padding(.vertical, 12)
            }
            .frame(width: 100)
            .background(Color("color3"))
            .cornerRadius(20, corners: [.bottomRight])
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .ignoresSafeArea()
        }
    }
}


//MARK: - Canvas
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenuView: .constant(false), depictedView: .constant(.showRepeatWordView))
    }
}
