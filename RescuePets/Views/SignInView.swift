//
//  SignInView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/2/21.
//

import SwiftUI

struct SignInView: View {
    
    @Binding var email : String
    @Binding var password : String
    var isSigned : Bool
    @Binding var show : Bool
    @EnvironmentObject var auth : AuthenticationModel
    
    var body: some View {
        VStack{
            VStack(spacing: 20){
                TextFieldCustom(placeholder: "Write your email", title: "Email", kind: $email, isSecureField: false)
                
                TextFieldCustom(placeholder: "Write your password",title: "Password", kind: $password, isSecureField: true)
                
                NormalButton(textButton: "Sign In") {
                    if email != "" && password != "" {
                        self.auth.signIn(email: email, password: password)
                    }
                }
                .opacity(!isSigned ? 1 : 0.8)
                .disabled(isSigned)
            }
        }
        .padding(.top, 50)
        .padding(.all, 20)
        .background(ThemeColors.white.color)
        .cornerRadius(20)

    }
}


