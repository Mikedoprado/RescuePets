//
//  TopBarItemsPreferenceKey.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/22/21.
//

import Foundation
import SwiftUI

struct TopBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TopBarItem] = []
    
    static func reduce(value: inout [TopBarItem], nextValue: () -> [TopBarItem]) {
        value += nextValue()
    }
}

struct TopBarItemViewModifier: ViewModifier {
    
    let tab : TopBarItem
    @Binding var selection: TopBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TopBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func topBarItem(tab: TopBarItem, selection: Binding<TopBarItem>) -> some View {
        modifier(TopBarItemViewModifier(tab: tab, selection: selection))
    }
}
