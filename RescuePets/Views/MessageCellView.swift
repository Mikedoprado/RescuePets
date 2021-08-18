//
//  MessageCellView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

struct MessageCellView: View {
    
//    @ObservedObject var message : MessageCellViewModel
    
    var body: some View {
        HStack {
            Image("profileImageBlue")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .center)
            VStack (alignment: .leading){
                Text("message.from")
                    .modifier(FontModifier(weight: .bold, size: .paragraph, color: .blueCuracao))
                
                HStack {
                    Text("message.text")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                    Spacer()
                    Text("1 weeks")
                        .modifier(FontModifier(weight: .bold, size: .caption, color: .gray))
                    
                }
            }
        }
        .padding(.top, 10)
//        .padding(.horizontal, 30)
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MessageCellView()
        }.previewLayout(.sizeThatFits)
        
    }
}
