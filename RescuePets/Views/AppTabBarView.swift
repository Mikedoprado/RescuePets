//
//  AppTabBarView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State var tabSelection: TabBarItem = .notification
    
    var body: some View {
        
        NavigationView {
            CustomTabBarContainerView(selection: $tabSelection) {
                
                AppTopBarView()
                    .tabBarItem(tab: .notification, selection: $tabSelection)
                
                Example2()
                    .tabBarItem(tab: .createStory, selection: $tabSelection)
                
                
                Example3()
                    .tabBarItem(tab: .messages, selection: $tabSelection)

                Example4()
                    .tabBarItem(tab: .profile, selection: $tabSelection)
                
            }
            .background(Color.clear)
            .navigationBarHidden(true)
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [.notification, .createStory, .messages, .profile]
    static var previews: some View {
        AppTabBarView()
    }
}

