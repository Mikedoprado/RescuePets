//
//  CustomTopBarView.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import SwiftUI

import SwiftUI

struct CustomTopBarView: View {
    
    let tabs: [TopBarItem]
    @Binding var selection : TopBarItem
    @Namespace private var namespace
    
    var body: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                topTabView(tab: tab)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            switchToTopTab(tab: tab)
                        }
                    }
            }
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(ThemeColors.white.color)
        )
        
    }
}

extension CustomTopBarView {

    private func topTabView(tab: TopBarItem) -> some View {
        VStack{
            Text(tab.title)
                .modifier(FontModifier(weight: .regular, size: .paragraph, color: (selection == tab) ? .white : .redSalsa))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .background(
            VStack{
                if selection == tab {
                    RoundedRectangle(cornerRadius: 1)
                        .foregroundColor(ThemeColors.redSalsa.color)
                        .cornerRadius(20)
                        .matchedGeometryEffect(id: "line_rectangle", in: namespace)
                }
            }
        )
    }
    
    private func switchToTopTab(tab: TopBarItem) {
        selection = tab
    }
    
}

struct CustomTopBarView_Previews: PreviewProvider {
    
    static let tabs: [TopBarItem] = [.general, .accepted, .created]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTopBarView(tabs: tabs, selection: .constant(tabs.first!))
        }
    }
}
