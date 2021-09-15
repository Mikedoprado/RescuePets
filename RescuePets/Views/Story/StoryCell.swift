//
//  StoryCell.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/6/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoryCell: View {
    
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var color = ThemeColors.darkGray
    @State var textButton = "I want to help"
    @State var profileImage = ""
    
    func showUser(){
        self.userViewModel.userRepository.loadUserById(userID: storyCellViewModel.userId) {  user in
            if let profileImage = user.profileImage{
                self.profileImage = profileImage
            }
        }
    }

    var body: some View {
        VStack(spacing:0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(ThemeColors.whiteClear.color)
                    .shadow(color: ThemeColors.redSalsaDark.color, radius: 20, x: 0.0, y: 0.0)
                
                VStack(spacing:0) {
                    HStack {
                        Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(ThemeColors.redSalsa.color)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(storyCellViewModel.kindOfStory)
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                            Text(storyCellViewModel.username.capitalized)
                                .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                        }
                        Spacer()
                        Text(storyCellViewModel.timestamp)
                            .modifier(FontModifier(weight: .bold, size: .caption, color: .halfGray))
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                   
                    AnimatedImage(url: URL(string: storyCellViewModel.presentImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .foregroundColor(ThemeColors.whiteClear.color)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 30)
                        
                    HStack(spacing: 5){
                        HStack {
                            DesignImage.profileImageRed.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                        .padding(.leading, 10)

                            Text("\(storyCellViewModel.numHelpers)")
                                .modifier(FontModifier(weight: .regular, size: .caption, color: .darkGray))
                                .padding(.trailing, 10)


                        }
                        .frame(height:40)
                        .background(ThemeColors.white.color)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        Spacer()
                        if userViewModel.userCellViewModel.user.id != storyCellViewModel.userId {
                            Button(action: {
                                storyViewModel.update(storyCellViewModel.story, user: userViewModel.userCellViewModel.user)
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 150, height: 40)
                                        .foregroundColor((storyCellViewModel.acceptedStory == "I want to help") ? ThemeColors.redSalsa.color : .clear)
                                    Text(storyCellViewModel.acceptedStory)
                                        .modifier(FontModifier(weight: .bold, size: .titleCaption, color: (storyCellViewModel.acceptedStory == textButton) ? ThemeColors.white : ThemeColors.redSalsa))
                                        
                                }
                            })
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
            }
        }
        .padding(.horizontal, 30)
        .onAppear{
            showUser()
        }

    }
}

//struct StoryCell_Previews: PreviewProvider {
//    static var previews: some View {
//        StoryCell(storyCellViewModel: StoryCellViewModel(story: Story), storyViewModel: StoryViewModel())
//    }
//}
