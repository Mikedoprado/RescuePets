//
//  StoryCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

struct StoryCellView: View {
    
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var username = ""
    
    func showUser(){
        self.userViewModel.userRepository.loadUserById(userID: storyCellViewModel.userId) {  user in
            if let username = user.username{
                self.username = username
            }
        }
    }
    
    var body: some View {
        HStack {
            HStack{
                Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                VStack (alignment: .leading){
                    Text(storyCellViewModel.kindOfStory)
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                    Text(username.capitalized)
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                    Text(storyCellViewModel.timestamp)
                        .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                }
                Spacer()
//                if user.id != storyCellViewModel.story.userId {
//                    HStack {
//                        Button{
//                            storyViewModel.update(storyCellViewModel.story, user: user)
//                        }label: {
//                            Image(storyCellViewModel.acceptedStory)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 30, height: 30)
//                        }
//                    }
//                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)

        }
        .background(ThemeColors.whiteClear.color)
        .cornerRadius(10)
        .padding(.horizontal, 30)
    }
}

//struct storyCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            StoryCellView()
//        }
//        .previewLayout(.sizeThatFits)
//    }
//
//}
