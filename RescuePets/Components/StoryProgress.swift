//
//  StoryProgress.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/17/21.
//

import SwiftUI

struct StoryProgress: View {
    var body: some View {
        VStack {
            VStack {
                HStack{
                    Image("pinDogActive" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack (alignment: .leading){
                        Text("Maltreatment")
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                        
                        HStack {
                            Text("username")
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            Spacer()
                        }
                    }
                    //                    MapActiveView(story: storyCellViewModel, latitude: storyCellViewModel.latitude, longitude: storyCellViewModel.longitude)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50,height: 50)
                        .foregroundColor(ThemeColors.whiteGray.color)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
//                ZStack{
//                    RoundedRectangle(cornerRadius: 0, style: .continuous)
//                        .frame( height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                        .foregroundColor(ThemeColors.whiteGray.color)
//                    VStack {
//                        HStack {
//                            Text("Progress")
//                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .halfGray)).padding(.leading, 20)
//                            Spacer()
//                        }
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 5, style: .continuous)
//                                .frame( height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(ThemeColors.white.color)
//                                .padding(.horizontal, 20)
//                            HStack {
//                                RoundedRectangle(cornerRadius: 5, style: .continuous)
//                                    .frame(width: 250, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                    .foregroundColor(ThemeColors.redSalsa.color)
//                                    .padding(.leading, 20)
//                                Spacer()
//                            }
//                        }
//                    }
//
//                }
            }
            
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0.0, y: 0.0)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
    }
}

struct StoryProgress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StoryProgress()
        }.previewLayout(.sizeThatFits)
    }
}
