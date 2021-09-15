//
//  TabBar.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/14/21.
//

import SwiftUI

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
                        case 1:
                            self.actionItem2()
                        case 2:
                            self.actionItem3()
                        case 3:
                            self.actionItem4()
                            selectedIndex = -1
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
        .frame(height: 90)
        .background(ThemeColors.white.color)
        .clipShape(
            RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20)
//            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(color: ThemeColors.lightGray.color, radius: 1, x: 0.0, y: 0.0)
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedIndex: .constant(-1), tabBarItemActive: [], actionItem1: {}, actionItem2: {}, actionItem3: {}, actionItem4: {})
    }
}
