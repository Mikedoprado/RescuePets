//
//  CounterHelpers.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/16/21.
//

import SwiftUI

struct CounterHelpers: View {
    
    @ObservedObject var storyCellViewModel : StoryCellViewModel
    var color : Color
    var body: some View {
        HStack {
            DesignImage.profileImageRed.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .padding(.leading, 10)
            
            Text("\(storyCellViewModel.numHelpers)")
                .modifier(FontModifier(weight: .regular, size: .caption, color: .darkGray))
                .padding(.trailing, 10)
            
            
        }
        .frame(height:40)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

//struct CounterHelpers_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterHelpers()
//    }
//}
