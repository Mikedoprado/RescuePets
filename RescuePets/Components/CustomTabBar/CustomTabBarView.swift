//
//  CustomTabBarView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection : TabBarItem
    @Namespace private var namespace
    
    
    var body: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            switchToTab(tab: tab)
                        }
                    }
            }
        }
        .padding(10)
        .background(
            RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20)
                .fill(ThemeColors.white.color)
                .ignoresSafeArea(edges:.bottom)
        )
        
    }
}

extension CustomTabBarView {

    private func tabView(tab: TabBarItem) -> some View {
        VStack{
            Image(tab.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            VStack{
                Spacer()
                if selection == tab {
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 50)
                        .frame(height: 2)
                        .foregroundColor(ThemeColors.redSalsa.color)
                        .matchedGeometryEffect(id: "line_rectangle", in: namespace)
                }
            }
        )

    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
    
}

struct CustomTabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [.notification, .createStory, .messages, .profile]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!))
        }
    }
}

