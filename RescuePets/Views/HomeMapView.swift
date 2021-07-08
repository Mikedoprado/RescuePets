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
    
    @ObservedObject private var locationManager = LocationManager() 
    @ObservedObject private var userViewModel = UserViewModel()
    @EnvironmentObject var auth: AuthenticationModel
    
    @State private var isShowPhotoLibrary = false
    @State private var showProfileUser = false
    @State var showCreateAlert : Bool = false
    @State private var image = Image("")
    @State private var inputImage: UIImage?
    @State var selectedIndex = 0
    @State var animCreateAlert = false
    @State var imageData : Data

    var tabBarItemActive = [
        "iconNotify:",
        "iconCamera:",
        "iconMessage:",
        "iconProfile:"
    ]
    
    var body: some View {
        ZStack{
            MapView()
                .ignoresSafeArea(.all)
            ThemeColors.black.color
                .opacity(0.4)
                .blendMode(.multiply)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    HStack(alignment: .center){
                        ForEach(0..<4) { index in
                            Button(action: {
                                if index == 1 {
                                    isShowPhotoLibrary.toggle()
                                    self.showProfileUser = false
                                }
                                if index == 2 {
                                    self.isShowPhotoLibrary = false
                                    self.showProfileUser = false
                                    self.auth.signOut()
                                }
                                if index == 3 {
                                    self.showProfileUser.toggle()
                                    self.isShowPhotoLibrary = false
                                }
                                
                                selectedIndex = index
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
                if showProfileUser {
                    ProfileView(user: userViewModel.userCellViewModel)
                        .offset(y: -40.0)
                        .animation(.easeIn)
                }
            }
            .ignoresSafeArea(edges: .bottom)

            if showCreateAlert {
                CreateAlertView(imageSelected: image, imageData: imageData, isShowing: $showCreateAlert, city: $locationManager.city, address: $locationManager.address)
                    .ignoresSafeArea(edges: .all)
            }
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
                self.animCreateAlert = true
            }
        }
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView(imageData: Data())
    }
}
