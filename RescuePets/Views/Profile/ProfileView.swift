//
//  ProfileView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/18/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject var storyViewModel : StoryViewModel
    @Binding var isShowing : Bool
    @Binding var isAnimating : Bool
    var textCreated = "Created"
    var textAccepted = "Accepted"
    var textLocation = "Location"
    var textBadges = "Your Badges"
    @State var showEditProfile = false
    @State var animEditProfile = false
    @State var showMenu = false
    @State var animateMenu = false
    
    func dismissView(){
        self.isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isShowing = false
        }
    }
    
    func showMenuPopUp(){
        self.showMenu = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateMenu = true
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    HStack {
                        Button {dismissView() } label: {
                            DesignImage.closeWhite.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        Spacer()
                        Button(action: {
                            self.showMenuPopUp()
                        }, label: {
                            HStack(spacing: 5){
                                ForEach(0..<3){ _ in
                                    Circle()
                                        .foregroundColor(ThemeColors.white.color)
                                        .frame(width: 6, height: 6)
                                }
                            }
                        })
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 20)
                    VStack{
                        AnimatedImage(url: URL(string: userViewModel.userCellViewModel.profileImage))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .background(ThemeColors.whiteGray.color)
                            .clipShape(Circle())
                        
                        VStack(alignment: .center, spacing: 0){
                            Text("\(userViewModel.userCellViewModel.username.capitalized)")
                                .modifier(FontModifier(weight: .bold, size: .subheadline, color: .white))
                            
                            Text("\(userViewModel.userCellViewModel.kindOfUser.capitalized)")
                                .modifier(FontModifier(weight: .regular, size: .subtitle, color: .whiteGray))
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    HStack(spacing:20){
                        VStack(alignment: .center, spacing: 0) {
                            Text(textCreated)
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .white))
                            Text("\(storyViewModel.amountCreatedStories)")
                                .modifier(FontModifier(weight: .bold, size: .caption, color: .whiteGray))
                        }
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 1, height: 20)
                            .foregroundColor(ThemeColors.white.color)
                        VStack(alignment: .center, spacing: 0) {
                            Text(textAccepted)
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .white))
                            Text("\(storyViewModel.amountAcceptedStories)")
                                .modifier(FontModifier(weight: .bold, size: .caption, color: .whiteGray))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        Text(textLocation)
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .white))
                        Spacer()
                        DesignImage.locationWorldWhite.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("\(userViewModel.userCellViewModel.location.capitalized)")
                            .modifier(FontModifier(weight: .bold, size: .titleCaption, color: .white))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
                .background(ThemeColors.redSalsa.color)
                HStack {
                    Text(textBadges)
                        .modifier(FontModifier(weight: .bold, size: .subtitle, color: .redSalsa))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                VStack{
                    BadgesView(userViewModel: userViewModel)
                }
                .padding(.bottom, 30)
                Spacer()
                
            }
            .background(ThemeColors.white.color)
            .offset(y: self.isAnimating ? 0 : UIScreen.main.bounds.height)
            .ignoresSafeArea(edges: .bottom)
            .blur(radius: showMenu ? 5 : 0)
            .animation(.spring(), value: self.isAnimating)
            
            if showEditProfile {
                EditProfileView(show: $showEditProfile, animateEdit: $animEditProfile)
            }
            
            if showMenu {
                ZStack{
                    ThemeColors.darkGray.color
                        .opacity(1)
                        .blendMode(.multiply)
//                        .padding(.horizontal, -30)
                        .ignoresSafeArea( edges: .all)
                        .onTapGesture {
                            self.showMenu = false
                        }
                    
                    VStack {
                        HStack {
                            Spacer()
                            MenuPopUp(actionEdit: {
                                self.showEditProfile = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.animEditProfile = showEditProfile
                                }
                            }, actionLogOut: {
                                self.dismissView()
                                self.userViewModel.userRepository.signOut()
                            }, showMenu: $showMenu, animateMenu: $animateMenu)
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 30)
                        Spacer()
                    }
                }
                
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ProfileView(isShowing: .constant(true), isAnimating: .constant(true))
//        }.previewLayout(.sizeThatFits)
//    }
//}


struct BadgesView: View {
    
    @ObservedObject var userViewModel : UserViewModel
    
    let layout =  [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: layout, spacing: 20){
            ForEach( userViewModel.userCellViewModel.badges, id: \.self){ item in
                item.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        print(item.achievement)
                    }
            }
        }
        .padding(.horizontal, 20)
    }
}
