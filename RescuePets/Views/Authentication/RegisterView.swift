//
//  RegisterView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/2/21.
//

import SwiftUI

struct RegisterView: View {
    
    @Binding var email : String
    @Binding var password : String
    @Binding var username : String
    var isSigned : Bool
    @Binding var show : Bool
    @Binding var showImagePicker : Bool
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject private var locationManager = LocationManager()
    @ObservedObject private var userRepository = UserRepository()
    
    @State var dropDownTitle = "Kind of user"
    @State var items = ["Casual", "Foundation", "Animalist", "Adopter"]
    @State var showKindUser = false
    @State var kindOfUser = ""
    @State var initialValueDropDown = false
    @State var animateDropDown = false
    
    @Binding var imageProfile : UIImage?
    @Binding var dataImageProfile : Data?
    @Binding var isLoading : Bool
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var showingAlertUsername = false
    
    var body: some View {
        VStack{
            VStack(spacing: 20){
                HStack {
                    Spacer()
                    VStack {
                        if imageProfile != nil {
                            Image(uiImage: imageProfile!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .background(ThemeColors.redSalsa.color)
                                .clipShape(Circle())
                        }else{
                            Image("profileImageRed")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .background(ThemeColors.redSalsa.color)
                                .clipShape(Circle())
                        }
                            
                        
                        Text("Add your profile picture")
                            .modifier(FontModifier(weight: .bold, size: .titleCaption, color: .redSalsa))
                    }
                    .onTapGesture {
                        self.showImagePicker = true
                    }
                    Spacer()
                }
                
                TextFieldCustom(placeholder: "Write your username",title: "Username", kind: $username, isSecureField: false )
                
                TextFieldCustom(placeholder: "Write your email", title: "Email", kind: $email, isSecureField: false)
                
                TextFieldCustom(placeholder: "Write your password",title: "Password", kind: $password, isSecureField: true)
                
                DropDownView(
                    title: $dropDownTitle,
                    items: $items,
                    selectedIndex: -1,
                    showOptions: $showKindUser,
                    kindOfStory: $kindOfUser,
                    initialValue: $initialValueDropDown,
                    animateDropDown: $animateDropDown) {
                        withAnimation {
                            self.showKindUser.toggle()
                            DispatchQueue.main.async {
                                self.animateDropDown.toggle()
                            }
                        }
                    }
                NormalButton(textButton: "Register") {
                    if username != ""{
                        self.userRepository.checkUsernameExist(username: username) { value in
                            if value{
                                showingAlertUsername = true
                                titleAlert = "Username was already taken"
                                messageAlert = "This username is already used for another user"
                            }else{
                                if email != "" && password != "" && username != "" && kindOfUser != ""{
                                    self.isLoading = true
                                    self.userViewModel.userRepository.createUser(username, email, password, location: locationManager.city.lowercased(), imageData: dataImageProfile, kindOfUser : kindOfUser.lowercased())
                                }
                            }
                        }
                    }

                }
                .opacity(!isSigned ? 1 : 0.8)
                .disabled(isSigned)
                .alert(isPresented:$showingAlertUsername) {
                    Alert(
                        title: Text(titleAlert),
                        message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                            showingAlertUsername = false
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


