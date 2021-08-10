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
    @State var repeatPassword: String = ""
    @ObservedObject var userViewModel : UserViewModel
    @EnvironmentObject var auth: AuthenticationModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @Binding var isAnimatingEditChangePassword : Bool
    @Binding var showChangePassword : Bool
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var showingAlertPassWord = false
    @State var showingDifferentPass = false
    
    func dismissView(){
        self.isAnimatingEditChangePassword = false
        self.showingAlertPassWord = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showChangePassword = false
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    fileprivate func chooseKindOfAlert(_ value: Bool, _ error: String?) {
        switch value {
        case true:
            self.showingAlertPassWord = true
            self.titleAlert = "Saving your password"
            self.messageAlert = "Your changes in your password was do it"
        case false:
            self.showingAlertPassWord = true
            self.titleAlert = "We have error"
            self.messageAlert = "\(String(describing: error!))"
        }
    }
    
    var body: some View {
        VStack(spacing:20){
            HStack(alignment: .top) {
                Text("Change \n your password")
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
            HStack{
                Text("If you want to change the password you need to log in again before to make this change.")
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            VStack(alignment: .center, spacing: 20){
                TextFieldCustom(placeholder: "Write your old password",title: "Old Password", kind: $oldPassword, isSecureField: true)
                
                TextFieldCustom(placeholder: "Write your new password",title: "New Password", kind: $newPassword, isSecureField: true)
                
                TextFieldCustom(placeholder: "Repeat your new password",title: "Repeat Password", kind: $repeatPassword, isSecureField: true)
                    .alert(isPresented:$showingAlertPassWord) {
                        Alert(
                            title: Text(titleAlert),
                            message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                                withAnimation {
                                    self.dismissView()
                                }
                            })
                        )
                    }
                
                NormalButton(textButton: "Done") {
                    if newPassword == repeatPassword {
                        self.auth.updatePassword(userEmail: userViewModel.userCellViewModel.email, oldPassword: self.oldPassword, newPassword: self.newPassword) { error, value in
                            self.chooseKindOfAlert(value, error)
                        }
                    }else{
                        self.showingDifferentPass = true
                        self.titleAlert = "Different Password"
                        self.messageAlert = "The new password and the repeat password aren't the same"
                    }
                }
                .alert(isPresented:$showingDifferentPass) {
                    Alert(
                        title: Text(titleAlert),
                        message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                            self.showingDifferentPass = false
                        })
                    )
                }
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
        .background(ThemeColors.white.color)
        .cornerRadius(20)
        .offset(y: self.isAnimatingEditChangePassword ? 0 : UIScreen.main.bounds.height)
        .animation(.spring())
        .ignoresSafeArea( edges: .all)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(userViewModel: UserViewModel(), isAnimatingEditChangePassword: .constant(true), showChangePassword: .constant(true))
    }
}
