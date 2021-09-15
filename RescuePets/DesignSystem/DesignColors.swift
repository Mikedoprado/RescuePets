//
//  DesignColors.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI

enum ThemeColors {
    
    case white
    case blueCuracao
    case goldenFlow
    case redSalsa
    case redSalsaDark
    case whiteSmashed
    case darkGray
    case gray
    case lightGray
    case halfGray
    case whiteGray
    case whiteClear
    case black

    var color : Color {
        switch self {
        case .white:
            return Color(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))
        case .blueCuracao:
            return Color(#colorLiteral(red: 0.1882352941, green: 0.737254902, blue: 0.7882352941, alpha: 1))
        case .goldenFlow:
            return Color(#colorLiteral(red: 0.9803921569, green: 0.8549019608, blue: 0.5019607843, alpha: 1))
        case .redSalsa:
            return Color(#colorLiteral(red: 0.9647058824, green: 0.2509803922, blue: 0.3098039216, alpha: 1))
        case .whiteSmashed:
            return Color(#colorLiteral(red: 0.9803921569, green: 0.9529411765, blue: 0.8901960784, alpha: 1))
        case .darkGray:
            return Color(#colorLiteral(red: 0.2274509804, green: 0.2274509804, blue: 0.2274509804, alpha: 1))
        case .gray:
            return Color(#colorLiteral(red: 0.4588235294, green: 0.4470588235, blue: 0.4470588235, alpha: 1))
        case .lightGray:
            return Color(#colorLiteral(red: 0.7058823529, green: 0.7058823529, blue: 0.7058823529, alpha: 1))
        case .halfGray:
            return Color(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1))
        case .whiteGray:
            return Color(#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1))
        case .black:
            return Color(#colorLiteral(red: 0.1007985225, green: 0.1010723503, blue: 0.09869561228, alpha: 1))
        case .whiteClear:
            return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        case .redSalsaDark:
            return Color(#colorLiteral(red: 0.8257176699, green: 0.2196078431, blue: 0.2823529412, alpha: 1))
        }
    }
}


