//
//  SkeletonView.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/27/21.
//

import SwiftUI

struct SkeletonView: View {

        var body: some View {
            HStack {
                Image("pinDogActive" )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack (alignment: .leading){
                    Text("storyCellViewModel.kindOfStory")
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                    Text("storyCellViewModel.username.capitalized")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                    Text("storyCellViewModel.timestamp")
                        .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                    }
                Spacer()
                
                    
                        HStack {
                            Button{
//                                storyCellViewModel.story.isActive.toggle()
//                                storyViewModel.update(storyCellViewModel.story, user: user)
                            }label: {
                                Image("storyCellViewModel.acceptedStory")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }
                        }
                    
                
            }
            .padding(.top, 10)
            .padding(.horizontal, 30)
            .redacted(reason: .placeholder)
        }
    
}

struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView()
    }
}
