//
//  ChatTextField.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/17/21.
//

import SwiftUI

struct ChatTextField: View {
    
    
    @Binding var message: String
    var action : () -> Void
    
    var body: some View {
        HStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(ThemeColors.white.color)
                TextField("Write your message", text: $message)
                    .foregroundColor(ThemeColors.darkGray.color)
                    .padding(.horizontal, 20)
            }
            .padding(.leading, 20)
            
            Button(action: self.action, label: {
                DesignImage.send.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
            })
            Spacer()
        }
        .frame(height: 50)
        .padding(.all, 10)
        .background(ThemeColors.blueCuracao.color)

    }
}

struct ChatTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatTextField(message: .constant(""), action: {})
        }.previewLayout(.sizeThatFits)
    }
}
