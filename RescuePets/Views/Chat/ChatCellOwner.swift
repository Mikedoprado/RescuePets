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
            HStack(alignment: .bottom){
                VStack(alignment: .leading, spacing: 10){
                    AnimatedImage(url: URL(string: profileImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(ThemeColors.lightGray.color)
                        .clipShape(Circle())
                }
                ZStack {
                    HStack{
                        Text(text)
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                        
                    }
                    .padding(.all, 15)
                }
                .background(
                    RoundedCornersShape(corners: [.topLeft,.topRight,.bottomRight], radius: 15)
                        .fill(ThemeColors.whiteClear.color)
                )
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
