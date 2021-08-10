//
//  ChangeEmailView.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/6/21.
//

import SwiftUI

import SwiftUI

struct ChangeEmailView: View {
    
    
    @ObservedObject var userViewModel : UserViewModel
    @EnvironmentObject var auth: AuthenticationModel
    @ObservedObject var signupVM = SignViewModel()
    @Binding var isAnimatingEditEmail : Bool
    @Binding var showChangeEmail : Bool
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var email: String = ""
    @State var oldEmail = ""
    @State var password = ""
    @State var showingAlertEmail = false
    @State var showingSameEmail = false
    @State var showSign = false
    @State var isLoading = false
    
    func dismissView(){
        self.isAnimatingEditEmail = false
        self.showingSameEmail = false
        self.showingAlertEmail = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showChangeEmail = false
        }
    }
    
    fileprivate func chooseKindOfAlert(_ value: Bool, _ error: String?) {
        switch value {
        case true:
            self.showingAlertEmail = true
            self.titleAlert = "Saving your email"
            self.messageAlert = "Your changes in your email was do it"
        case false:
            self.showingAlertEmail = true
            self.titleAlert = "We have error"
            self.messageAlert = "\(String(describing: error!))"
        }
    }
    
    fileprivate func signInToChangeEmail() {
        auth.signIn(email: oldEmail.lowercased(), password: password) { error, value in
            switch value {
            case true:
                self.showSign = false
                self.titleAlert = "Login"
                self.messageAlert = "Now you can change the email"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showingSameEmail = true
                }
            case false:
                self.showSign = false
                self.titleAlert = "Login"
                if let  err = error { self.messageAlert = err }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showingSameEmail = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20){
                HStack(alignment: .top) {
                    Text("Change \n your email")
                        .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                    Spacer()
                    Button {
                        withAnimation {
                            dismissView()
                        }
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
                .padding(.top, 50)
                VStack(spacing: 20){
                    HStack(alignment: .top){
                        Text("If you want to change the email you need to log in again before to make this change.")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                            .lineLimit(3)
                        Spacer()
                        Button(action: {self.showSign = true}, label: {
                            Text("Log In")
                                .modifier(FontModifier(weight: .bold, size: .largeButtonText, color: .lightGray))
                        })
                        .frame(width: 100, height: 50)
                        .background(ThemeColors.whiteGray.color)
                        .cornerRadius(10)
                    }
                    
                    TextFieldCustom(placeholder: userViewModel.userCellViewModel.email,title: "Email", kind: $email, isSecureField: false)
                        .alert(isPresented:$showingSameEmail) {
                            Alert(
                                title: Text(titleAlert),
                                message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                                    self.showingSameEmail = false
                                })
                            )
                        }
                    NormalButton(textButton: "Done") {
                        if email != userViewModel.userCellViewModel.email {
                            auth.updateEmail(email: email) { error, value in
                                chooseKindOfAlert(value, error)
                            }
                            self.showSign = false
                        }else {
                            self.showSign = false
                            self.titleAlert = "Email repeated"
                            self.messageAlert = "The email that you write is the same that we have in the database"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.showingSameEmail = true
                            }
                        }
                    }
                    .alert(isPresented:$showingAlertEmail) {
                        Alert(
                            title: Text(titleAlert),
                            message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                                withAnimation {
                                    dismissView()
                                }
                            })
                        )
                    }
                }
                Spacer()
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 30)
            .background(ThemeColors.white.color)
            .cornerRadius(20)
            
            if showSign {
                CustomAlertView(email: $oldEmail, password: $password, showAlert: $showSign) {
                    signInToChangeEmail()
                }
            }
        }
        .offset(y: self.isAnimatingEditEmail ? 0 : UIScreen.main.bounds.height)
        .animation(.spring())
    }
}



struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView(userViewModel: UserViewModel(), isAnimatingEditEmail: .constant(true), showChangeEmail: .constant(true))
    }
}
