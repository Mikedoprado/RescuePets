//
//  BackShapeView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/18/21.
//

import SwiftUI
import CoreGraphics

struct BackShapeView: View {
    
    let size = CGRect(x: 0, y: 0, width: 50, height: 50)
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 30, y: 40))
            path.addLine(to: CGPoint(x: 40, y: 30))
            path.closeSubpath()
        }
        .fill(ThemeColors.blueCuracao.color)
    }
}

struct BackShapeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackShapeView()
        }.previewLayout(.sizeThatFits)
    }
}

