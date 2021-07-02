//
//  ChatCellOwner.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ChatCellOwner: View {
    var body: some View {
        HStack (alignment: .top, spacing: 20){
            DesignImage.profileImageBlue.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            VStack (alignment: .leading){
                Text("Username")
                    .modifier(FontModifier(weight: .bold, size: .subheadline, color: .blueCuracao))
                Text("The owner of a missing cat is asking for help. My baby has been missing for over a month now, and I want him back so badly, said Mrs. Brown, a 56-year-old woman. Mrs. Brown lives by herself in a trailer park near Clovis.")
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
            }
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
