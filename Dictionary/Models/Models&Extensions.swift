//
//  Models&Extensions.swift
//  Dictionary
//
//  Created by Виталя on 18.12.2022.
//

import Foundation
import SwiftUI

//MARK: - Models
struct TextFieldWord {
    var english: String
    var ukranian: String
}

enum OnboardingField: Hashable {
    case englishFieldInFocus
    case ukranianFieldInFocus
}

//MARK: - Extensions
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


