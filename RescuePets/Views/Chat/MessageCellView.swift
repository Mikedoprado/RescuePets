//
//  MessageCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageCellView: View {
    
    @ObservedObject var chat : ChatCellViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @State var profileImage = ""
    @State var username = "username"
    @Binding var isActive : Bool

    fileprivate func showUser(_ user: User) {
        if let username = user.username , let profileImage = user.profileImage{
            self.profileImage = profileImage
            self.username = username.capitalized
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                AnimatedImage(url: URL(string:  profileImage))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .background(ThemeColors.lightGray.color)
                    .clipShape(Circle())
                VStack (alignment: .leading){
                    HStack {
                        VStack(alignment: .leading) {
                            Text(username)
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                            Text(chat.lastMessage)
                                .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                        }
                        
                        Spacer()
                        Text("\(chat.timestamp)")
                            .modifier(FontModifier(weight: .bold, size: .caption, color: .lightGray))
                    }
                }
                .redacted(reason: self.profileImage != "" ? [] : .placeholder)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 70)
        .background(ThemeColors.white.color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onChange(of: chat.user) { user in
            showUser(user)
            isActive = true
        }
    }
}

//struct MessageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            MessageCellView(chat: .constant(Chat()))
//        }.previewLayout(.sizeThatFits)
//
//    }
//}
