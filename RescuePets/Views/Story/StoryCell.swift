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
    var actionHelp : ()->()
    var actionShowActive : ()->()

    var body: some View {
        VStack(spacing:0) {
            ZStack {
                AnimatedImage(url: URL(string: storyCellViewModel.presentImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(ThemeColors.whiteClear.color)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        self.actionShowActive()
                    }

                VStack{
                    VStack{
                        HStack(spacing: 5){
                            Spacer()
                            CounterHelpers(storyCellViewModel: storyCellViewModel, color: ThemeColors.white.color)
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    VStack(spacing:0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(storyCellViewModel.kindOfStory)
                                    .modifier(FontModifier(weight: .bold, size: .subtitle, color: .redSalsa))
                                HStack(spacing: 10){
                                    Image("pin\(storyCellViewModel.kindOfAnimal)Active" )
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(ThemeColors.redSalsa.color)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading,spacing: 0){
                                        Text(storyCellViewModel.username.capitalized)
                                            .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                                        Text(storyCellViewModel.timestamp)
                                            .modifier(FontModifier(weight: .bold, size: .caption, color: .halfGray))
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                            if userViewModel.userCellViewModel.user.id != storyCellViewModel.userId && storyCellViewModel.numHelpers <= 50 {
                                
                                Image(!storyCellViewModel.acceptedStory ? "storyAdd" : "storyAcept")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 25, height: 25)
                                    .onTapGesture {
                                        self.actionHelp()
                                    }
                            }
                        }
                        .padding(.all, 20)
                    }
                    .background(ThemeColors.white.color)
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        self.actionShowActive()
                    }
                }
                
            }
            
        }
        
    }
}



