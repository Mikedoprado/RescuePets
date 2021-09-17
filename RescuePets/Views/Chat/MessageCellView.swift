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

    @State var username = ""
    @State var profilePicture = ""
  
    func showUserInfo(){
        
//        guard let currentUserId = DBInteract.auth.currentUser?.uid else {return}
//        let from = ((currentUserId != chat.acceptedStoryUser) ? chat.acceptedStoryUser : chat.ownerStoryUser)
//
//        self.userViewModel.userRepository.loadUserById(userID: from) { user in
//            if let username = user.username, let profilePicture = user.profileImage{
//                self.username = username
//                self.profilePicture = profilePicture
//
//            }
//        }
    }
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: profilePicture))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .center)
                .clipShape(Circle())
            VStack (alignment: .leading){
                HStack {
                    Text(username.capitalized)
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .blueCuracao))
                    Spacer()
                    Text("\(chat.timestamp)")
                        .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                }
            }
        }
        .padding(.top, 10)
        .onAppear{
            showUserInfo()
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
