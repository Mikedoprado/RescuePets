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
    
    @EnvironmentObject var auth: AuthenticationModel
    
    @State private var isShowPhotoLibrary = false
    @State private var showProfileUser = false
    @State private var showCreateStory : Bool = false
    @State private var showNotifcationsView = false
    @State var changeViewInNotifyView = false
    @State private var inputImage: UIImage?
    @State var selectedIndex = -1
    @State var animCreateStory = false
    @State var animProfileUser = false
    @State var animNotify = false
    @State var city = ""
    @State var address = ""
    @State var imageSelected : ImageSelected = ImageSelected(imageData: Data(), image: Image(""))

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
                MapView()
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
                                    self.showProfileUser = false
                                    self.showNotifcationsView = false
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
                ProfileView(isShowing: $showProfileUser, isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showCreateStory {
                CreateStoryView(imageSelected:$imageSelected,isShowing: $animCreateStory)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showNotifcationsView {
                NotifyView(showNotify: $showNotifcationsView, isAnimating: $animNotify, changeView: changeViewInNotifyView)
                    .ignoresSafeArea()
            }
        }
        .background(ThemeColors.redSalsa.color)
        .ignoresSafeArea(edges: .all)
    }
    
    func loadImage() {
        if let inputImage = inputImage {
            if let imageData = inputImage.jpegData(compressionQuality: 0.8){
                let imageData = imageData
                let image = Image(uiImage: inputImage)
                self.imageSelected = ImageSelected(imageData: imageData, image: image)
            }
            self.isShowPhotoLibrary = false
            showCreateStory = true
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.animCreateStory = showCreateStory
            }
        }
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView()
    }
}

