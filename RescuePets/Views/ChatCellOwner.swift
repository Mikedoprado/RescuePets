//
//  ChatCellOwner.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ChatCellOwner: View {
    var body: some View {
        HStack (alignment: .top, spacing: 10){
            DesignImage.profileImageBlue.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            ZStack {
                VStack (alignment: .leading){
                    Text("Username")
                        .modifier(FontModifier(weight: .bold, size: .subheadline, color: .white))
                    Text("The owner of a missing cat is asking for help. My baby has been missing for over a month now, and I want him back so badly¡.")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                }
                .padding(.all, 20)
            }
            .background(ThemeColors.blueCuracao.color)
            .cornerRadius(20)
            
            
            Spacer()
        }
    }
}

struct ChatCellOwner_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ChatCellOwner()
        }.previewLayout(.sizeThatFits)
        
    }
}
