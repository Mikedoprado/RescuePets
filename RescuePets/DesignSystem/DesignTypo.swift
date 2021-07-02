//
//  DesignTypo.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

enum FontSize {
    case title, headline, subheadline, paragraph, caption, smallButtonText, subtitle, largeButtonText
    
    var size: CGFloat {
        switch self {
        case .title:
            return 25
        case .headline:
            return 22
        case .subheadline:
            return 20
        case .paragraph:
            return 16
        case .caption:
            return 12
        case .smallButtonText:
            return 12
        case .subtitle:
            return 18
        case .largeButtonText:
            return 18
        }
    }
}


struct FontModifier: ViewModifier {
    var weight: Font.Weight
    var size: FontSize
    var color: ThemeColors
    func body(content: Content) -> some View {
        content
            .font(.system(size: size.size, weight: weight))
            .foregroundColor(color.color)
    }
}
