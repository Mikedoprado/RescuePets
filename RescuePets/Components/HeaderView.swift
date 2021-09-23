//
//  HeaderView.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/12/21.
//

import SwiftUI

struct HeaderView: View {

    enum ColorChoose{
        case white, black
    }
    
    enum Alignment {
        case top, center
    }

    @Binding var title : String
    var actionDismiss : (() -> Void)
    var color: ColorChoose
    var alignment : Alignment
    var closeButtonIsActive = true
    
    var body: some View {
        HStack (alignment: alignment == .top ? .top : .center){
            Text(title)
                .modifier(FontModifier(weight: .bold, size: .title, color: (color == .black) ? .darkGray : .white))
            Spacer()
            if closeButtonIsActive {
                HStack(spacing: 30) {
                    Button (action: self.actionDismiss, label: {
                        Image((color == .black) ? "btnCloseBlack" : "btnCloseWhite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    })
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView(title: .constant("Title"), actionDismiss: {}, color: .black, alignment: .center)
        }.previewLayout(.sizeThatFits)
    }
}
