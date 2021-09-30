//
//  SignInView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI

struct Authentication: View {
    
    @StateObject var signupVM = SignViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var auth : UserViewModel
    
    @State var password: String = ""
    @State var username: String = ""
    @State var isFocused = false
    
    @State var showSignIn = false
    @State var showRegister = false
    @State var showImagePicker = false
    
    @State private var inputImage : UIImage?
    @State private var dataImage : Data?
//    @State var imageSelected : ImageSelected?
    @State var isLoading = false
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack {
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
                                
                                SignInView(email: $signupVM.email, password: $password, isSigned: signupVM.isSignUpComplete, show: $showSignIn, isLoading: $isLoading)
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
                                RegisterView(email: $signupVM.email, password: $password, username: $username, isSigned: signupVM.isSignUpComplete, show: $showRegister, showImagePicker: $showImagePicker, imageProfile: $inputImage, dataImageProfile: $dataImage, isLoading : $isLoading)
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
            .ignoresSafeArea(edges: .all)
            .onTapGesture {
                self.isFocused = false
                self.hideKeyboard()
            }
            .onAppear(perform: {
                signupVM.email = ""
                password = ""
            })
            if isLoading {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: ThemeColors.white.color))
                            .scaleEffect(2)
                            .blendMode(.normal)
                        Spacer()
                    }
                    Spacer()
                }
                .background(ThemeColors.darkGray.color)
                .blendMode(.multiply)
                .ignoresSafeArea( edges: .all)
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker(selectedImage: $inputImage)
                .ignoresSafeArea(edges: .all)
        })
        .onChange(of: auth.userRepository.signedIn, perform: { value in
            if value{
                isLoading = false
            }
        })
        .onChange(of:self.showRegister, perform: { value in
            if !value{
                self.inputImage = nil
                self.dataImage = nil
            }
        })
    }
        
    
    func loadImage(){
        if let imageData = inputImage?.jpegData(compressionQuality: 1){
            self.dataImage = imageData
        }
    }
}


struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}


