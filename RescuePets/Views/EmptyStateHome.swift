//
//  EmptyStateHome.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/24/21.
//

import SwiftUI

struct EmptyStateHome: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack{
                DesignImage.textLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .padding(.top, 100)
                DesignImage.emptyStateHelp.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 20)
                Text("Do you wanna \n start to help?")
                    .multilineTextAlignment(.center)
                    .modifier(FontModifier(weight: .bold, size: .title, color: .white))
                Text("Now you can receive an story in your city and help some animal in your area if you are a foundation, animalist, or passionate about helping animals this is your app.")
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .modifier(FontModifier(weight: .regular, size: .paragraph, color: .white))
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

struct EmptyStateHome_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateHome()
    }
}
