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
    @StateObject var storyViewModel = StoryViewModel()
    @State private var isShowPhotoLibrary = false
    @State private var showProfileUser = false
    @State private var showCreateStory : Bool = false
    @State private var showNotifcationsView = false
    @State var changeViewInNotifyView = false
    @State var inputImage : UIImage?
    @State var newImage : UIImage?
    @State var dataImage = Data()
    @State var selectedIndex = -1
    @State var animCreateStory = false
    @State var animProfileUser = false
    @State var animNotify = false
    @State var city = ""
    @State var address = ""
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
    
    func showCreate() {
        self.showCreateStory = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animCreateStory = true
        }
    }
    
    var body: some View {
        ZStack{
            ZStack {
                ThemeColors.redSalsa.color
                    .ignoresSafeArea(.all)
                EmptyStateHome()
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                if showNotifcationsView {
                    NotifyView(
                        storyViewModel: storyViewModel,
                        showNotify: $showNotifcationsView,
                        isAnimating: $animNotify,
                        changeView: changeViewInNotifyView,
                        showTabBar: $showTabBar)
                        .ignoresSafeArea()
                }
                
                if showMessages {
                    MessagesView(showMessages: $showMessages, isAnimating: $isAnimatingMessages, showTabBar: $showTabBar)
                }
                
                VStack {
                    Spacer()
                    TabBar(selectedIndex: $selectedIndex, tabBarItemActive: tabBarItems,
                           actionItem1: {
                                showNotifcationsView = true
                                showCreateStory = false
                                showMessages = false
                                showProfileUser = false
                           },
                           actionItem2: {
                                showCreate()
                                showNotifcationsView = false
                                showMessages = false
                                showProfileUser = false
                           },
                           actionItem3: {
                                showMessages = true
                            showCreateStory = false
                                showNotifcationsView = false
                                showProfileUser = false
                           },
                           actionItem4: {
                                showProfileUser = true
                                showMessages = false
                                showCreateStory = false
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
            
            if showProfileUser {
                
                ThemeColors.darkGray.color
                    .opacity(1)
                    .blendMode(.multiply)
                    .ignoresSafeArea( edges: .all)
                    
                
                ProfileView(
                    storyViewModel: storyViewModel,
                    isShowing: $showProfileUser,
                    isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
            }
            
            if showCreateStory{
                CreateStoryView(
                    inputImage: $newImage,
                    imageData: $dataImage,
                    showCreateStory: $showCreateStory,
                    isShowing: $animCreateStory,
                    storyViewModel: storyViewModel
                )
                    
            }
        }
        .background(ThemeColors.darkGray.color)
        .ignoresSafeArea(edges: .all)

        
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView()
    }
}



