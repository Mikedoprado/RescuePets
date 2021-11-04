//
//  AppTopBarView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

struct AppTopBarView: View {
    
    @State var tabSelection: TopBarItem = .general
    @StateObject var storyViewModel = StoryViewModel()
    
    var body: some View {
        CustomTopBarContainerView(selection: $tabSelection) {
            
            StoriesListView(storyViewModel: storyViewModel, kind: .general)
                .topBarItem(tab: .general, selection: $tabSelection)
            
            StoriesListView(storyViewModel: storyViewModel, kind: .accepted)
                .topBarItem(tab: .accepted, selection: $tabSelection)
            
            StoriesListView(storyViewModel: storyViewModel, kind: .created)
                .topBarItem(tab: .created, selection: $tabSelection)
        }
    }
}

struct AppTopBarView_Previews: PreviewProvider {
    static let tabs: [TopBarItem] = [.general, .accepted, .created]
    static var previews: some View {
        AppTopBarView()
    }
}
