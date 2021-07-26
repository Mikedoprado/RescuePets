//
//  ProfileView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/18/21.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var userViewModel = UserViewModel()
    @Binding var isShowing : Bool
    @Binding var isAnimating : Bool
    
    var body: some View {
            VStack {
                HStack {
                    Text("Profile")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    Button {
                        self.isAnimating = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.isShowing = false
                        }
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, 30)
                VStack{
                    DesignImage.profileImageRed.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
 
                    Text(userViewModel.userCellViewModel.username)
                        .modifier(FontModifier(weight: .bold, size: .subheadline, color: .gray))
                    
                    
                    Text("Kind of user")
                        .modifier(FontModifier(weight: .regular, size: .subtitle, color: .redSalsa))
                    
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
            .background(ThemeColors.white.color)
            .cornerRadius(20)
            .offset(y: self.isAnimating ? 0 :  UIScreen.main.bounds.height)
            .ignoresSafeArea(edges: .bottom)
            .animation(.default)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView(isShowing: .constant(true), isAnimating: .constant(true))
        }.previewLayout(.sizeThatFits)
    }
}

struct Badge: View {
    var body: some View {
        Circle()
            .frame(width: 60, height: 60)
            .foregroundColor(ThemeColors.white.color)
    }
}
