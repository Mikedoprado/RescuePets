//
//  ChatCellOwner.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatCellOwner: View {
    
    var text: String
    var username: String
    var profileImage: String
    
    var body: some View {
        VStack {
            HStack{
                VStack (alignment: .leading, spacing: 10){
                    AnimatedImage(url: URL(string: profileImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                ZStack {
                    HStack{
                        Text(text)
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                        
                    }
                    .padding(.all, 15)
                }
                .background(ThemeColors.blueCuracao.color)
                .cornerRadius(20)
               Spacer()
            }
            
            
        }
    }
}

struct ChatCellOwner_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ChatCellOwner(text: "", username: "", profileImage: "")
        }.previewLayout(.sizeThatFits)
        
    }
}
