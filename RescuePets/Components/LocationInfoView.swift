//
//  LocationInfoView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/7/21.
//

import SwiftUI

struct LocationInfoView: View {
    
    var city : String
    var address : String 
    
    var body: some View {
        HStack{
            VStack{
                
                HStack{
                    DesignImage.pinLocationWhite.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Spacer()
            }
            .frame(width: 30)
            .padding()
            .background(ThemeColors.redSalsa.color)

            VStack (alignment: .leading, spacing: 10){
                Text("Story location")
                    .modifier(FontModifier(weight: .bold, size: .subheadline, color: .darkGray))
                HStack{
                    Text("City")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    Spacer()
                    Text(city.capitalized)
                        .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                }
                HStack{
                    Text("Address")
                        .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                    Spacer()
                    Text(address)
                        .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                }
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        .frame(height: 120)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct LocationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationInfoView(city: "Medellin", address: "Calle 13 # 43D - 79")
        }.previewLayout(.sizeThatFits)
    }
}
