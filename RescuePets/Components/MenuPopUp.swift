//
//  MenuPopUp.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/23/21.
//

import SwiftUI

struct MenuPopUp: View {
    
    var actionEdit : () -> Void
    var actionLogOut : () -> Void
    @Binding var showMenu : Bool
    @Binding var animateMenu : Bool
    
    func dismissView(){
        animateMenu = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showMenu = false
            self.actionEdit()
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(ThemeColors.whiteClear.color)
                    .frame(width: 220, height: 130)
                VStack {
                    Button(action: {
                        dismissView()
                    }, label: {
                        HStack {
                            Text("Edit Profile")
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            Spacer()
                            DesignImage.editProfile.image
                                .frame(width: 30, height: 30)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                    })
                    
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(ThemeColors.whiteGray.color)
                        .frame(height: 1)
                    Button(action:{
                        self.actionLogOut()
                        self.showMenu = false
                    }, label: {
                        HStack {
                            Text("Log out")
                                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            Spacer()
                            DesignImage.logOut.image
                                .frame(width: 30, height: 30)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                    })
                }
                .frame(width: 220)
            }
        }
        .scaleEffect(CGSize(width: animateMenu ? 1.0 : 0, height: animateMenu ? 1.0 : 0), anchor: .center)
    }
}

struct MenuPopUp_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuPopUp(actionEdit: {}, actionLogOut: {}, showMenu: .constant(true), animateMenu: .constant(true))
        }
        .previewLayout(.sizeThatFits)
    }
}
