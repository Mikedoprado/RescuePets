//
//  CustomTabBarContainerView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    let content : Content
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    var body: some View {
        
        ZStack(alignment: .bottom){
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [.notification, .createStory, .messages, .profile]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!), content: {
            Color.red
        })
    }
}
