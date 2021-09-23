//
//  CommentCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentCellView: View {
    
    @ObservedObject var commentCellViewModel : CommentCellViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @State var username = ""
    @State var profileImage = ""
    
    func showUser(){
        self.userViewModel.userRepository.loadUserById(userID: commentCellViewModel.from) {  user in
            if let username = user.username, let profileImage = user.profileImage{
                self.username = username
                self.profileImage = profileImage
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AnimatedImage(url: URL(string: profileImage))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(ThemeColors.lightGray.color)
                .frame(width: 25, height: 25)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(username.capitalized)
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                
                Text(commentCellViewModel.text)
                    .modifier(FontModifier(weight: .light, size: .paragraph, color: .gray))
                
                Text(commentCellViewModel.timestamp)
                    .modifier(FontModifier(weight: .bold, size: .caption, color: .lightGray))
                
            }
        }
        .padding(.horizontal, 20)
        .onAppear{
            self.showUser()
        }
    }
}

//struct CommentCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentCellView(commentCellViewModel: CommentCellViewModel())
//    }
//}
