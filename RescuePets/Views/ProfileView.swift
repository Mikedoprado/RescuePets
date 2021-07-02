//
//  ProfileView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/18/21.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView (.vertical, showsIndicators: true) {
            VStack {
                HStack {
                    Text("Profile")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    Button {
                        
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.top, 25)
                .padding(.horizontal, 30)
                HStack{
                    DesignImage.profileImageRed.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                    VStack (spacing: 0){
                        HStack{
                            Text("Username")
                                .modifier(FontModifier(weight: .bold, size: .subheadline, color: .gray))
                            Spacer()
                        }
                        HStack{
                            Text("Kind of user")
                                .modifier(FontModifier(weight: .regular, size: .subtitle, color: .redSalsa))
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 15, height: 10, alignment: .center)
                                .foregroundColor(ThemeColors.redSalsa.color)
                                .padding(.trailing, 5)
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 30)
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(ThemeColors.lightGray.color)
                            .frame(height: UIScreen.main.bounds.width - 40)
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40 , height: 40)
                            .foregroundColor(ThemeColors.white.color)
                    }
                    
                    HStack{
                        Text("Last picture")
                            .modifier(FontModifier(weight: .bold, size: .caption, color: .blueCuracao))
                        Spacer()
                        Text("2 week ago")
                            .modifier(FontModifier(weight: .bold, size: .caption, color: .lightGray))
                    }
                    Text("The owner of a missing cat is asking for help. My baby has been missing for over a month now, and I want him back so badly, said Mrs. Brown, a 56-year-old woman. Mrs. Brown lives by herself in a trailer park near Clovis. She said that Clyde, her 7-year-old cat, didn't come home for dinner more than a month ago. The next morning he didn't appear for breakfast either. After Clyde missed an extra-special lunch, she called the police.")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                        .padding(.vertical, 20)
                        
                }
                .padding(.horizontal, 30)
                
            }
            HStack {
                VStack {
                    Spacer()
                    HStack {
                        Text("Badges")
                            .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                            .padding(.top, 20)
                        Spacer()
                    }
                    
                    HStack{
                        Badge()
                        Spacer()
                        Badge()
                        Spacer()
                        Badge()
                        Spacer()
                        Badge()
                        Spacer()
                        Badge()
                    }.padding(.bottom, 40)
                    
                    
                }
                .frame(maxHeight: 150)
                .padding(.horizontal, 30)
                .background(ThemeColors.blueCuracao.color)
            }
        }
        .background(ThemeColors.white.color)
        .cornerRadius(20)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct Badge: View {
    var body: some View {
        Circle()
            .frame(width: 60, height: 60)
            .foregroundColor(ThemeColors.white.color)
    }
}