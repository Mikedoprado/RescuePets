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
    @Binding var user : User
    var body: some View {
        HStack {
            Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            VStack (alignment: .leading){
                Text(storyCellViewModel.kindOfStory)
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                Text(storyCellViewModel.username)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                Text(storyCellViewModel.timestamp)
                    .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                }
            Spacer()
            if user.id != storyCellViewModel.story.userId{
                HStack {
                    Button{
                        storyCellViewModel.story.isActive.toggle()
                        storyViewModel.update(storyCellViewModel.story, user: user)
                    }label: {
                        Image(storyCellViewModel.acceptedStory)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .padding(.top, 10)
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
