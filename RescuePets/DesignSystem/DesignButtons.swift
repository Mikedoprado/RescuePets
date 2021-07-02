//
//  DesignButtons.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/22/21.
//

import SwiftUI

struct NormalButton: View {
    var textButton: String
    var action: () -> Void
    var body: some View {
        
        Button(action: action, label: {
            Spacer()
            Text(textButton)
                .modifier(FontModifier(weight: .bold, size: .largeButtonText, color: .white))
            Spacer()
        })
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 18)
        .background(ThemeColors.redSalsa.color)
        .cornerRadius(10)

    }
}

struct SmallButton: View {
    var icon : String
    var body: some View {
        Button{
            print("tapped! \(icon)")
        } label: {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
        }

    }
}

struct ButtonAuth: View {
    
    @Binding var show : Bool
    @Binding var hide : Bool
    var nameButton : String
    @Binding var password : String
    @Binding var username : String
    @Binding var email : String
    
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(height:60)
                    .foregroundColor(ThemeColors.white.color)
                HStack {
                    Text(nameButton)
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .darkGray))
                    Spacer()
                    DesignImage.dropDown.image
                        .rotation3DEffect(
                            .degrees(show ? 180 : 0),
                            axis: (x: 0.0, y: 0.0, z: 1.0)
                        )
                }.padding(.horizontal, 20)
            }.onTapGesture {
                self.show.toggle()
                self.hide = false
                self.email = ""
                self.password = ""
                self.username = ""
            }
            if show{
                Spacer()
            }
        }
    }
}
