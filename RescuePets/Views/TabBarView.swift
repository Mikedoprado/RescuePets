//
//  TabBarView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/1/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @StateObject var storyViewModel = StoryViewModel()
    @State private var isShowPhotoLibrary = false
    @State private var showProfileUser = true
    @State private var showCreateStory : Bool = true
    @State private var showNotifcationsView = true
    @State var changeViewInNotifyView = true
    @State var inputImage : UIImage?
    @State var newImage : UIImage?
    @State var dataImage = Data()
    @State var selectedIndex = -1
    @State var animCreateStory = true
    @State var animProfileUser = true
    @State var animNotify = true
    @State var city = ""
    @State var address = ""
    @State var showMessages = true
    @State var isAnimatingMessages = true
    @State var showTabBar = true
    
    var tabBarItems = [
        "iconNotify:",
        "iconCamera:",
        "iconMessage:",
        "iconProfile:"
    ]
    
    init(){
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.white
        
    }
    var body: some View {
        NavigationView {
            TabView{
                NotifyView(storyViewModel: storyViewModel, showNotify: $showNotifcationsView, isAnimating: $animNotify, showTabBar: $showTabBar)
                    .tabItem {
                        
                        Image("iconNotify:Active")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    }
                CreateStoryView(
                    inputImage: $newImage,
                    imageData: $dataImage,
                    showCreateStory: $showCreateStory,
                    isShowing: $animCreateStory,
                    storyViewModel: storyViewModel
                )
                    .tabItem {
                        
                        Image("iconCamera:Active")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    }
                
                MessagesView(showMessages: $showMessages, isAnimating: $isAnimatingMessages, showTabBar: $showTabBar)
                    .tabItem {
                        
                        Image("iconMessage:Active")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    }
                
                ProfileView(
                    storyViewModel: storyViewModel,
                    isShowing: $showProfileUser,
                    isAnimating: $animProfileUser)
                    .ignoresSafeArea(edges: .all)
                    .tabItem {
                        
                        Image("iconProfile:Active")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    }
                
                
            }
            .ignoresSafeArea()
            .onChange(of: showTabBar) { value in
                UITabBar.appearance().isHidden = value
            }
        }
        .navigationBarHidden(true)
        
        //        .offset(y: showTabBar ? 0 : screen.height)
        
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}


struct Example1 : View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct Example2 : View {
    var body: some View {
        Text("Hello, Michael!")
    }
}

struct Example3 : View {
    var body: some View {
        Text("Hello, Stella!")
    }
}


struct Example4 : View {
    var body: some View {
        Text("Hello, Manuel!")
    }
}
