//
//  EditProfileView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct EditProfileView: View {
    
    @State var email: String = ""
    @State var username: String = ""
    
    var body: some View {
            VStack{
                HStack {
                    Text("Edit profile")
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
                
                VStack(alignment: .center, spacing: 20){
                    DesignImage.profileImageRed.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.top, 50)
                    Text("Change your profile picture")
                        .modifier(FontModifier(weight: .regular, size: .paragraph , color: .redSalsa))
                        .padding(.bottom, 40)
                        .onTapGesture {
                            print("change the image")
                        }
                    TextFieldCustom(placeholder: "Write your username", kind: $username, isSecureField: false)
                        .padding(.top, -40)
                    TextFieldCustom(placeholder: "Write your email", kind: $email, isSecureField: false)
                    
                    HStack{
                        Text("Kind of story")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .darkGray))
                        Spacer()
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 15, height: 10, alignment: .center)
                            .foregroundColor(ThemeColors.darkGray.color)
                            .padding(.trailing, 5)
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Button{
                            print("forget my password")
                        }label: {
                            Text("Change your password")
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    
                    NormalButton(textButton: "Save changes"){
                        print("save changes")
                    }
                    Button{
                        print("forget my password")
                    }label: {
                        Text("Delete Account")
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                            .lineLimit(1)
                    }
                }
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            .background(ThemeColors.white.color)
            .cornerRadius(20)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
