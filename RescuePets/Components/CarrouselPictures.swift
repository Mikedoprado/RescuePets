//
//  CarrouselPictures.swift
//  RescuePets
//
//  Created by Michael do Prado on 9/28/21.
//

import SwiftUI

struct CarrouselPictures : View {
    
    @Binding var images : [UIImage]
    @State var screen = UIScreen.main.bounds.width
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x - 30)
        if diff < 100 {
            scale = 1 + (100 - diff) / 500
        }
        
        return scale
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(images, id: \.self) { image in
                GeometryReader { proxy in
                    
                    let scale = getScale(proxy: proxy)
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (screen / 1.2) - 60 , height: (screen / 1.2) - 60)
                        .background(ThemeColors.whiteGray.color)
                        .cornerRadius(10)
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                        .scaleEffect(CGSize(width: scale, height: scale))
                }
                .frame(width:screen / 1.2 ,height: screen - 50)
            }
        }
        .padding(.horizontal, 20)
    }
}

//struct CarrouselPictures_Previews: PreviewProvider {
//    static var previews: some View {
//        CarrouselPictures()
//    }
//}
