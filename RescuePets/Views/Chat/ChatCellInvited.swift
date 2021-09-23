//
//  ChatCellInvited.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/30/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatCellInvited: View {
    
    var text: String
    var username: String
    var profileImage: String
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom){
                Spacer()
                ZStack {
                    HStack{
                        Text(text)
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    }
                    .padding(.all, 15)
                }
                .background(RoundedCornersShape(corners: [.topLeft,.topRight,.bottomLeft], radius: 20)
                                .fill(ThemeColors.whiteGray.color))
                
                VStack (alignment: .trailing, spacing: 10){
                    AnimatedImage(url: URL(string: profileImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(ThemeColors.lightGray.color)
                        .clipShape(Circle())
                }
                
            }
        }
    }
}

struct ChatCellInvited_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ChatCellInvited(text: "", username: "", profileImage: "")
        }.previewLayout(.sizeThatFits)
    }
}
