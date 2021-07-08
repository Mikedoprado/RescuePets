//
//  DropDownView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/7/21.
//

import SwiftUI

struct DropDownView: View {
    
    @Binding var title : String
    @Binding var items : [String]
    @State var selectedIndex = -1
    @Binding var showOptions : Bool
    @Binding var kindOfAlert : String
    var action: () -> Void
    
    var body: some View {
        VStack (spacing: 0){
            Button(action: self.action, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .frame(height: 60)
                        .foregroundColor(ThemeColors.redSalsa.color)
                    HStack {
                        Text(title)
                            .modifier(FontModifier(weight: .bold, size: .subheadline, color: .white))
                        Spacer()
                        Text(self.selectedIndex != -1 ? items[selectedIndex] : "")
                            .multilineTextAlignment(.trailing)
                            .modifier(FontModifier(weight: .bold, size: .titleCaption, color: .white))
                        ((!self.showOptions && self.selectedIndex != -1) ? DesignImage.alertAcept.image :  DesignImage.dropDownWhite.image)
                        
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .rotationEffect(.degrees( self.showOptions ? 180 : 0))
                            .animation(.default)
                    }.padding(.horizontal, 30)
                }
            })
            
            if self.showOptions {
                ForEach(0..<items.count) { index in
                    Button(action: {
                        self.selectedIndex = index
                        self.kindOfAlert = items[index]
                    }, label: {
                        HStack {
                            Text(items[index])
                                .modifier(FontModifier(weight: .bold, size: .paragraph, color: (self.selectedIndex == index) ? .white : .halfGray))
                                .padding(.leading, 30)
                                .animation(.default)
                            Spacer()
                            ((self.selectedIndex == index) ?
                                DesignImage.alertAcept.image : DesignImage.alertAdd.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 30)
                                .animation(.default)
                        }
                        .frame(height: 60)
                        .background((self.selectedIndex == index) ?  ThemeColors.redSalsa.color : Color.white)
                    })
                    
                }
            }
            
            
        }
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DropDownView(title: .constant("Title"), items: .constant([]), showOptions: .constant(true), kindOfAlert: .constant(""), action: {} )
        }.previewLayout(.sizeThatFits)
    }
}
