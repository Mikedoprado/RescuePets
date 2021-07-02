//
//  SignInView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI

struct Authentication: View {
    
    @ObservedObject var signupVM = SignViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var auth : AuthenticationModel
    
    @State var password: String = ""
    @State var username: String = ""
    @State var isFocused = false
    
    @State var showSignIn = false
    @State var showRegister = false
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ScrollView(.vertical) {
                HStack{
                    VStack(alignment: .center, spacing: 20){
                        DesignImage.logo.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .padding(.top, 40)

                        ZStack {
                            if showSignIn{
                                SignInView(email: $signupVM.email, password: $password, isSigned: signupVM.isSignUpComplete, show: $showSignIn, auth: _auth)
                                    .offset(y:10)
                            }
                            ButtonAuth(show: $showSignIn, hide: $showRegister, nameButton: "Sign In with email", password: $password, username: $username, email: $signupVM.email)
                        }
                        HStack {
                            Spacer()
                            Button{
                                print("forget my password")
                            }label: {
                                Text("Forgot your password")
                                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .white))
                                    .lineLimit(1)
                            }
                        }
                        .padding(.top, showSignIn ? 10 : 0)
                        ZStack {
                            if showRegister{
                                RegisterView(email: $signupVM.email, password: $password, username: $username, isSigned: signupVM.isSignUpComplete, show: $showRegister, auth: _auth)
                                    .offset(y:10)
                            }
                            ButtonAuth(show: $showRegister, hide: $showSignIn, nameButton: "Register with email", password: $password, username: $username, email: $signupVM.email)
                        }
                        HStack(alignment: .center){
                            Text("or sign in with")
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: .white))
                            Spacer()
                            HStack(spacing: 40){
                                SmallButton(icon: "logoFacebook")
                                
                                SmallButton(icon: "logoGoogle")
                                
                                SmallButton(icon: "logoApple")
                            }
                        }
                        .padding(.top, showRegister ? 10 : 0)
                        .padding(.bottom, 30)
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .background(ThemeColors.redSalsa.color)
            .padding(.bottom, keyboardHandler.keyboardHeight)
            .animation(.default)
            .ignoresSafeArea(edges: .all)
            .onTapGesture {
                self.isFocused = false
                self.hideKeyboard()
            }
            .onAppear(perform: {
                signupVM.email = ""
                password = ""
            })
    }
}


struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        
        Authentication()
    }
}


