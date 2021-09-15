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
            HStack(alignment: .top){
                Spacer()
                ZStack {
                    HStack{
                        Text(text)
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                    }
                    .padding(.all, 15)
                }
                .background(RoundedCornersShape(corners: [.topLeft,.topRight,.bottomLeft], radius: 20)
                                .fill(ThemeColors.redSalsa.color))
                
                VStack (alignment: .trailing, spacing: 10){
                    AnimatedImage(url: URL(string: profileImage))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(ThemeColors.lightGray.color)
                        .padding(.top, 10)
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
