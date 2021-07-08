//
//  ActiveDetailView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/24/21.
//

import SwiftUI

struct ActiveDetailView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Active")
                    .modifier(FontModifier(weight: .bold, size: .title, color: .darkGray))
                Spacer()
                HStack(spacing: 30) {
                    Button {
                        
                    } label: {
                        DesignImage.accept.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                    Button {
                        
                    } label: {
                        DesignImage.trash.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                    Button {
                        
                    } label: {
                        DesignImage.closeBlack.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                }
            }
            .padding(.top, 25)
            HStack {
                Image("pinCatActive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                VStack (alignment: .leading){
                    Text("Kind of alert")
                        .modifier(FontModifier(weight: .bold, size: .paragraph, color: .redSalsa))
                    
                    HStack {
                        Text("Username")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .lightGray))
                        Spacer()
                    }
                }
                Button{
                    
                }label:{
                    DesignImage.message.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.top, 10)
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(ThemeColors.lightGray.color)
                    .frame(height: UIScreen.main.bounds.width - 40)
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40 , height: 40)
                    .foregroundColor(ThemeColors.white.color)
            }
            Text("The owner of a missing cat is asking for help. My baby has been missing for over a month now, and I want him back so badly, said Mrs. Brown, a 56-year-old woman. Mrs. Brown lives by herself in a trailer park near Clovis. She said that Clyde, her 7-year-old cat, didn't come home for dinner more than a month ago. The next morning he didn't appear for breakfast either. After Clyde missed an extra-special lunch, she called the police.")
                .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                .padding(.vertical, 10)
            HStack{
                VStack{
                    DesignImage.pinLocationWhite.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                }
                .padding()
                .background(ThemeColors.redSalsa.color)
                
                VStack (alignment: .leading, spacing: 10){
                    Text("Your Current location")
                        .modifier(FontModifier(weight: .bold, size: .subheadline, color: .darkGray))
                    HStack{
                        Text("City")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                        Spacer()
                        Text("Medellín")
                            .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                    }
                    HStack{
                        Text("Address")
                            .modifier(FontModifier(weight: .regular, size: .paragraph, color: .gray))
                        Spacer()
                        Text("Manila")
                            .modifier(FontModifier(weight: .regular, size: .caption, color: .gray))
                    }
                }
                
                Spacer()
            }
            .frame(height: 120)
            .background(ThemeColors.whiteGray.color)
            .cornerRadius(10)
            Spacer()
        }
        .padding(.horizontal, 30)
        .background(ThemeColors.white.color)
        .cornerRadius(20)
    }
}

struct ActiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveDetailView()
    }
}
