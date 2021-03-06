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
    @Binding var kindOfStory : String
    @Binding var initialValue : Bool
    @Binding var animateDropDown : Bool
    var action: () -> Void
    
    
    fileprivate func chooseOption(index: Int) {
        self.selectedIndex = index
        self.kindOfStory = items[index]
//        self.animateDropDown.toggle()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.showOptions.toggle()
//        }
    }
    
    var body: some View {
        VStack (spacing: 0){
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .frame(height: 60)
                    .foregroundColor(ThemeColors.redSalsa.color)
                HStack {
                    Text(title)
                        .modifier(FontModifier(weight: .bold, size: .titleCaption, color: .white))
                    Spacer()
                    Text(self.selectedIndex != -1 ? items[selectedIndex] : "")
                        .multilineTextAlignment(.trailing)
                        .modifier(FontModifier(weight: .bold, size: .titleCaption, color: .white))
                    ((!self.showOptions && self.selectedIndex != -1) ? DesignImage.storyAcept.image :  DesignImage.dropDownWhite.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(self.selectedIndex == -1 && !self.showOptions ? 180 : 0))
                }
                .padding(.horizontal, 20)
            }
            .onTapGesture {
                self.action()
            }
            if self.showOptions {
                ForEach(0..<items.count) { index in
                    HStack {
                        Text(items[index])
                            .modifier(FontModifier(weight: .bold, size: .paragraph, color: (self.selectedIndex == index) ? .white : .halfGray))
                            .padding(.leading, 20)
                        Spacer()
                        ((self.selectedIndex == index) ?
                            DesignImage.storyAcept.image : DesignImage.storyAdd.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 20)
                    }
                    .frame(height: 60)
                    .background((self.selectedIndex == index) ?  ThemeColors.redSalsa.color : Color.white)
                    .onTapGesture {
                        chooseOption(index: index)
                        self.action()
                    }
                    
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .onChange(of: initialValue, perform: { value in
            self.selectedIndex = -1
        })

    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DropDownView(title: .constant("Title"), items: .constant([]), showOptions: .constant(true), kindOfStory: .constant(""), initialValue: .constant(false), animateDropDown: .constant(false), action: {} )
        }.previewLayout(.sizeThatFits)
    }
}
