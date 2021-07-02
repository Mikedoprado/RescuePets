//
//  BackShapeView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/18/21.
//

import SwiftUI
import CoreGraphics

struct BackShapeView: View {
    
    let size = UIScreen.main.bounds
    
    var body: some View {
        Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: size.width))
//            path.addQuadCurve(to: CGPoint(x: size.width , y: size.width ), control: CGPoint(x: size.width / 2 , y: size.height / 3))
            path.addCurve(to: CGPoint(x: size.width , y: size.width ), control1: CGPoint(x: size.width / 3 , y: size.height / 3), control2: CGPoint(x: size.width - 100  , y: size.width + 100))
            path.addLine(to: CGPoint(x: size.width, y: size.width))
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.closeSubpath()

            
        }
        .fill(ThemeColors.redSalsa.color)
    }
}

struct BackShapeView_Previews: PreviewProvider {
    static var previews: some View {
        BackShapeView()
    }
}

