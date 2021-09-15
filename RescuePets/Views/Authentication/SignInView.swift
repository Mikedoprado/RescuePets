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
    @EnvironmentObject var userViewModel : UserViewModel
    @Binding var isLoading : Bool
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var showingAlertSign = false

    var body: some View {
        VStack{
            VStack(spacing: 20){
                TextFieldCustom(placeholder: "Write your email", title: "Email", kind: $email, isSecureField: false)
                
                TextFieldCustom(placeholder: "Write your password",title: "Password", kind: $password, isSecureField: true)
                
                NormalButton(textButton: "Sign In") {
                    if email != "" && password != "" {
                        self.userViewModel.userRepository.signIn(email: email, password: password) {  error, value in
                            
                            if !value {
                                if let message = error {
                                    showingAlertSign = true
                                    titleAlert = "Incorrect information"
                                    messageAlert = message
                                }
                            }else{
                                self.isLoading = true
                            }
                        }
                    }
                }
                .opacity(!isSigned ? 1 : 0.8)
                .disabled(isSigned)
                .alert(isPresented:$showingAlertSign) {
                    Alert(
                        title: Text(titleAlert),
                        message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                            showingAlertSign = false
                        })
                    )
                }
            }
        }
        .padding(.top, 50)
        .padding(.all, 20)
        .background(ThemeColors.white.color)
        .cornerRadius(20)
    }
}


