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
    @ObservedObject private var userViewModel = UserViewModel()
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
    
    var tabBarItemActive = [
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
    
    var body: some View {
        ZStack{
            ZStack {
                ThemeColors.redSalsa.color
                    .cornerRadius(20)
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
                    NotifyView(showNotify: $showNotifcationsView, isAnimating: $animNotify, changeView: changeViewInNotifyView, user: $userViewModel.userCellViewModel.user)
                        .ignoresSafeArea()
                }
                
                if showMessages {
                    MessagesView(showMessages: $showMessages, isAnimating: $isAnimatingMessages)
                }
                VStack {
                    Spacer()
                    TabBar(selectedIndex: $selectedIndex, tabBarItemActive: tabBarItemActive,
                           actionItem1: {
                                self.showNotifcationsView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.animNotify = true
                                }
                           },
                           actionItem2: {
                                isShowPhotoLibrary = true
                           },
                           actionItem3: {
                                self.showMessages = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAnimatingMessages = true
                                }
                           },
                           actionItem4: {
                                self.showProfileUser = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.animProfileUser = showProfileUser
                                }
                           })
                        .sheet(isPresented: $isShowPhotoLibrary, onDismiss: loadImage, content: {
                            ImagePicker(selectedImage: $inputImage)
                                .ignoresSafeArea(edges: .all)
                        })
                }
                .offset(y: (showMessages || showNotifcationsView || isShowPhotoLibrary) ? UIScreen.main.bounds.height : 0)
            }
            .blur(radius: showProfileUser ? 5 : 0)
            .scaleEffect(CGSize(width: showProfileUser ? 0.95 : 1.0, height: showProfileUser ? 0.95 : 1.0))
            .ignoresSafeArea(edges: .bottom)
            .animation(.spring())
            
            if showProfileUser {
                
                ThemeColors.darkGray.color
                    .opacity(1)
                    .blendMode(.multiply)
                    .ignoresSafeArea( edges: .all)
                
                ProfileView(isShowing: $showProfileUser, isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showCreateStory {
                CreateStoryView(imageSelected:$imageSelected,isShowing: $animCreateStory)
                    .ignoresSafeArea(edges: .all)
            }
            
            
        }
        .background(ThemeColors.darkGray.color)
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


struct TabBar: View {
    
    @Binding var selectedIndex : Int
    var tabBarItemActive : [String]
    var actionItem1 : ()->Void
    var actionItem2 : ()->Void
    var actionItem3 : ()->Void
    var actionItem4 : ()->Void
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                ForEach(0..<4) { index in
                    Button(action: {
                        selectedIndex = index
                        switch index {
                        case 0:
                            self.actionItem1()
                            self.selectedIndex = -1
                        case 1:
                            self.actionItem2()
                        case 2:
                            self.actionItem3()
                        case 3:
                            self.actionItem4()
                        default:
                            print("any button press")
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
        
    }
}
