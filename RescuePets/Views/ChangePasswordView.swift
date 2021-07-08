//
//  ChangePasswordView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State var oldPassword: String = ""
    @State var newPassword: String = ""
    
    var body: some View {
            VStack{
                HStack(alignment: .top) {
                    Text("Change \n your password")
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
                    TextFieldCustom(placeholder: "Write your old password", kind: $oldPassword, isSecureField: true)
                        
                    TextFieldCustom(placeholder: "Write your new password", kind: $newPassword, isSecureField: true)
                    
                    TextFieldCustom(placeholder: "Repeat your new password", kind: $newPassword, isSecureField: true)

                    NormalButton(textButton: "Save new password") {
                        print("new password")
                    }

                }
                .padding(.vertical, 30)
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            .background(ThemeColors.white.color)
            .cornerRadius(20)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
