//
//  ChatCellInvited.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/30/21.
//

import SwiftUI

struct ChatCellInvited: View {
    var body: some View {
        HStack (alignment: .top, spacing: 10){
            Spacer()
            ZStack {
                VStack (alignment: .trailing){
                    Text("Username")
                        .modifier(FontModifier(weight: .bold, size: .subheadline, color: .white))
                    Text("The owner of a missing cat is asking for help. My baby has been missing for over a month now, and I want him back so badly, said Mrs. Brown, a 56-year-old woman. Mrs. Brown lives by herself in a trailer park near Clovis.")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                }
                .padding(.all, 20)
            }
            .background(ThemeColors.redSalsa.color)
            .cornerRadius(20)
            DesignImage.profileImageRed.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
        }
        
    }
}

struct ChatCellInvited_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ChatCellInvited()
        }.previewLayout(.sizeThatFits)
    }
}
