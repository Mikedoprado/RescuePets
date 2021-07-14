//
//  HomeMapView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct HomeMapView: View {
    
    
    @ObservedObject private var userViewModel = UserViewModel()
    @ObservedObject var alertListVM = AlertViewModel()
    @EnvironmentObject var auth: AuthenticationModel
    
    @State private var isShowPhotoLibrary = false
    @State private var showProfileUser = false
    @State private var showCreateAlert : Bool = false
    @State private var showNotifcationsView = false
    @State var changeViewInNotifyView = false
    @State private var image = Image("")
    @State private var inputImage: UIImage?
    @State var selectedIndex = -1
    @State var animCreateAlert = false
    @State var animProfileUser = false
    @State var animNotify = false
    @State var imageData : Data
    @State var mapImage = Image("")
    @State var mapData : Data?
    @State var city = ""
    @State var address = ""

    var tabBarItemActive = [
        "iconNotify:",
        "iconCamera:",
        "iconMessage:",
        "iconProfile:"
    ]
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack{

            EmptyStateHome()
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            if isShowPhotoLibrary {
                MapView(thumbImage: $mapImage, mapData: $mapData)
                    .ignoresSafeArea(.all)
                ThemeColors.black.color
                    .opacity(0.4)
                    .blendMode(.multiply)
                    .ignoresSafeArea(.all)
            }
            
            VStack {
                Spacer()
                VStack {
                    HStack(alignment: .center){
                        ForEach(0..<4) { index in
                            Button(action: {
                                selectedIndex = index
                                if index == 0 {
                                    self.showNotifcationsView.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.animNotify = true
                                    }
                                }
                                if index == 1 {
                                    isShowPhotoLibrary.toggle()
                                }
                                if index == 2 {
                                    self.auth.signOut()
                                }
                                if index == 3 {
                                    self.showProfileUser.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        self.animProfileUser = showProfileUser
                                    }
                                }
                            }, label: {
                                Spacer()
                                Image( selectedIndex == index ? "\(tabBarItemActive[index])Active" : "\(tabBarItemActive[index])Inactive")
                                Spacer()
                            })
                        }
                    }
                    .padding(.bottom, 20)
                }
                .frame(height: 100)
                .background(ThemeColors.white.color)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage, content: {
                    ImagePicker(selectedImage: $inputImage)
                        .ignoresSafeArea(edges: .all)
                })

            }
            .ignoresSafeArea(edges: .bottom)
            
            if showProfileUser {
                ProfileView(user: userViewModel.userCellViewModel, isShowing: $showProfileUser, isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showCreateAlert {
                CreateAlertView(
                    imageSelected: image,
                    imageData: imageData,
                    imageMapData: mapData!,
                    isShowing: $animCreateAlert
                )
                    .ignoresSafeArea(edges: .all)
            }
            
            if showNotifcationsView {
                NotifyView(alertListVM: alertListVM, showNotify: $showNotifcationsView, isAnimating: $animNotify, changeView: changeViewInNotifyView)
                    .ignoresSafeArea()
            }
        }
        .background(ThemeColors.redSalsa.color)
        .ignoresSafeArea(edges: .all)
        .onAppear{
            self.selectedIndex = -1
        }
    }
    
    func loadImage() {
        if let inputImage = inputImage {
            if let imageData = inputImage.jpegData(compressionQuality: 0.8){
                self.imageData = imageData
            }
            
            image = Image(uiImage: inputImage)
            self.isShowPhotoLibrary = false
            showCreateAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.animCreateAlert = showCreateAlert
            }
        }
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView(imageData: Data(), mapData: Data())
    }
}

struct EmptyStateHome: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                DesignImage.textLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .padding(.top, 100)
                DesignImage.emptyStateHelp.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 20)
                Text("Do you wanna \n start to help?")
                    .multilineTextAlignment(.center)
                    .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                Text("Now you can receive an alert in your city and help some animal in your area if you are a foundation, animalist, or passionate about helping animals this is your app.")
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}
