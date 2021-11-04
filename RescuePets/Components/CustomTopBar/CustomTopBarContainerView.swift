//
//  CustomTopBarContainerView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

import SwiftUI

struct CustomTopBarContainerView<Content:View>: View {
    
    @Binding var selection: TopBarItem
    @State private var tabs: [TopBarItem] = []
    
    let content : Content
    
    init(selection: Binding<TopBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    var body: some View {
        
        ZStack(alignment: .top){
            content
                .ignoresSafeArea()
            
            VStack(alignment:.leading, spacing: 0) {
                Text(selection.title)
                    .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                CustomTopBarView(tabs: tabs, selection: $selection)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .background(ThemeColors.redSalsa.color)
            .ignoresSafeArea( edges: .top)
        }
        .background(ThemeColors.redSalsaDark.color)
        .onPreferenceChange(TopBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTopBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TopBarItem] = [.general, .accepted, .created]
    
    static var previews: some View {
        CustomTopBarContainerView(selection: .constant(tabs.first!), content: {
            ThemeColors.redSalsa.color
        })
    }
}
