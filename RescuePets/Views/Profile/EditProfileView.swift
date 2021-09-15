//
//  EditProfileView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @StateObject private var keyboardHandler = KeyboardHandler()
    @Binding var show : Bool
    @Binding var animateEdit : Bool
    @State var dropDownTitle = "Kind of user"
    @State var items = ["Casual", "Foundation", "Animalist", "Adopter"]
    @State var showKindUser = false
    @State var kindOfUser = ""
    @State var initialValueDropDown = false
    @State var username = ""
    @State var email = ""
    @State var imageSelected : ImageSelected?
    @State private var inputImage: UIImage?
    @State var sectionTitle = "Edit profile"
    // show and imagePicker
    @State var showImagePicker = false
    @State var showingAlert = false
    @State var titleAlert = ""
    @State var messageAlert = ""
    
    // show and animate edit email
    @State var showChangeEmail = false
    @State var animChangeEmail = false
    // show and animate edit password
    @State var showChangePassword = false
    @State var animChangePassword = false
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissView(){
        self.showingAlert = false
        self.animateEdit = false
        self.username = ""
        self.email = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.show = false
        }
    }
    
    func chooseKindOfAlert(_ value: Bool, _ error: String?) {
        switch value {
        case true:
            self.showingAlert = true
            self.titleAlert = "Saving your profile"
            self.messageAlert = "Your changes in your profile was do it"
        case false:
            self.showingAlert = true
            self.titleAlert = "We have error"
            self.messageAlert = "\(String(describing: error!))"
        }
    }
    
    var body: some View {
        ZStack {
            VStack{
                
                HeaderView(title: $sectionTitle, actionDismiss: {
                    self.dismissView()
                }, color: .black, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .center, spacing: 20){
                        Button(action: {
                            self.showImagePicker = true
                        }, label: {
                            VStack{
                                if imageSelected != nil {
                                    imageSelected?.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .background(ThemeColors.whiteGray.color)
                                        .clipShape(Circle())
                                }else{
                                    AnimatedImage(url: URL(string: userViewModel.userCellViewModel.profileImage))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .background(ThemeColors.whiteGray.color)
                                        .clipShape(Circle())
                                }
                                Text("Change your profile picture")
                                    .modifier(FontModifier(weight: .regular, size: .paragraph , color: .redSalsa))
                                    .onTapGesture {
                                        print("change the image")
                                    }
                            }
                        })
                        .padding(.vertical, 20)
                        
                        TextFieldCustom(placeholder: userViewModel.userCellViewModel.username, title: "Username", kind:$username, isSecureField: false)
                        
                        DropDownView(title: $dropDownTitle, items: $items, showOptions: $showKindUser, kindOfStory: $kindOfUser, initialValue: $initialValueDropDown, action: {
                            self.showKindUser.toggle()
                        })
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.showChangeEmail = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        self.animChangeEmail = true 
                                    }
                                }
                            }, label: {
                                Text("Change your email")
                                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                                    .lineLimit(1)
                            })
                            Spacer()
                        }
                        HStack {
                            Button{
                                withAnimation {
                                    self.showChangePassword = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        self.animChangePassword = true
                                    }
                                }
                            }label: {
                                Text("Change your password")
                                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        
                        NormalButton(textButton: "Save changes"){
                            self.userViewModel.updateUserInfo(
                                username: username,
                                kindOfUser: kindOfUser,
                                imageData: imageSelected != nil ? imageSelected!.imageData : nil, userViewModel: userViewModel) { error, value in
                                chooseKindOfAlert(value, error)
                            }
                        }
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text(titleAlert),
                                message: Text(messageAlert),dismissButton: .default(Text("Ok"), action: {
                                    withAnimation {
                                        dismissView()
                                    }
                                })
                            )
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
                .padding(.bottom, keyboardHandler.keyboardHeight)
            }
            .background(ThemeColors.white.color)
            .cornerRadius(20)
            .offset(y: self.animateEdit ? 0 : UIScreen.main.bounds.height)
            .animation(.spring())
            .onTapGesture {
                self.hideKeyboard()
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(selectedImage: $inputImage)
                    .ignoresSafeArea(edges: .all)
            })
            if showChangeEmail {
                ChangeEmailView(isAnimatingEditEmail: $animChangeEmail, showChangeEmail: $showChangeEmail)
//                    .padding(.horizontal, -30)
                
            }
            if showChangePassword{
                ChangePasswordView(isAnimatingEditChangePassword: $animChangePassword, showChangePassword: $showChangePassword)
//                    .padding(.horizontal, -30)
            }
        }
    }
    
    func loadImage(){
        self.showImagePicker = false
        if let newImage = inputImage {
            if let imageData = newImage.jpegData(compressionQuality: 0.8){
                let image = Image(uiImage: newImage)
                imageSelected = ImageSelected(imageData: imageData, image: image)
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(show: .constant(true), animateEdit: .constant(true))
    }
}
