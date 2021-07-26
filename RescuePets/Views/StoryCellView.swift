//
//  StoryCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

struct StoryCellView: View {
    
    var body: some View {
        HStack {
            DesignImage.pinCatActive.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            VStack (alignment: .leading){
                Text("Maltreatment")
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                Text("username")
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                Text("1 week ago")
                    .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                }
            Spacer()
            
                HStack {
                    Button{

                    }label: {
                        DesignImage.storyAcept.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    
                }
            
        }
        .padding(.top, 10)
        .padding(.horizontal, 30)
    }
}

struct storyCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            StoryCellView()
        }
        .previewLayout(.sizeThatFits)
    }

}
