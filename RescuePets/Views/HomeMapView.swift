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
    
    @EnvironmentObject var userViewModel : UserViewModel
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
    @State var showMessages = false
    @State var isAnimatingMessages = false
    @State var showTabBar = true
    
    var tabBarItems = [
        "iconNotify:",
        "iconCamera:",
        "iconMessage:",
        "iconProfile:"
    ]
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func dismissView( show: inout Bool, animating: inout Bool){
        show = true
        animating = true
    }
    
    func loadImage() {
        if let inputImage = inputImage {
            if let imageData = inputImage.jpegData(compressionQuality: 0.8){
                let image = Image(uiImage: inputImage)
                self.imageSelected = ImageSelected(imageData: imageData, image: image)
            }
            self.isShowPhotoLibrary = false
            showCreateStory = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animCreateStory = showCreateStory
            }
        }
    }
    
    var body: some View {
        ZStack{
            ZStack {
                ThemeColors.redSalsa.color
//                    .cornerRadius(20)
                    .ignoresSafeArea(.all)
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
                
                if showNotifcationsView {
                    NotifyView(showNotify: $showNotifcationsView, isAnimating: $animNotify, changeView: changeViewInNotifyView, showTabBar: $showTabBar)
                        .ignoresSafeArea()
                }
                
                if showMessages {
                    MessagesView(showMessages: $showMessages, isAnimating: $isAnimatingMessages)
                }
                
                VStack {
                    Spacer()
                    TabBar(selectedIndex: $selectedIndex, tabBarItemActive: tabBarItems,
                           actionItem1: {
                                showNotifcationsView = true
                                isShowPhotoLibrary = false
                                showMessages = false
                                showProfileUser = false
                           },
                           actionItem2: {
                                isShowPhotoLibrary = true
                                showNotifcationsView = false
                                showMessages = false
                                showProfileUser = false
                           },
                           actionItem3: {
                                showMessages = true
                                isShowPhotoLibrary = false
                                showNotifcationsView = false
                                showProfileUser = false
                           },
                           actionItem4: {
                                showProfileUser = true
                                showMessages = false
                                isShowPhotoLibrary = false
                                showNotifcationsView = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    animProfileUser = showProfileUser
                                }
                           })
                }
                .offset(y: !showTabBar ? UIScreen.main.bounds.height : 0)
            }
            .blur(radius: showProfileUser ? 5 : 0)
            .scaleEffect(CGSize(width: showProfileUser ? 0.95 : 1.0, height: showProfileUser ? 0.95 : 1.0))
            .ignoresSafeArea(edges: .bottom)
            .animation(.default)
            
            if showProfileUser {
                
                ThemeColors.darkGray.color
                    .opacity(1)
                    .blendMode(.multiply)
                    .ignoresSafeArea( edges: .all)
                    
                
                ProfileView(isShowing: $showProfileUser, isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showCreateStory {
                CreateStoryView(imageSelected: $imageSelected, isShowing: $animCreateStory)
                    .ignoresSafeArea(edges: .all)
            }
        }
        .background(ThemeColors.darkGray.color)
        .ignoresSafeArea(edges: .all)
        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage, content: {
            ImagePicker(selectedImage: $inputImage)
                .ignoresSafeArea(edges: .all)
        })
        
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView()
    }
}



