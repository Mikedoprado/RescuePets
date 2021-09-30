//
//  MapInfoView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/16/21.
//

import SwiftUI

struct MapInfoView: View {

//    @ObservedObject var story : StoryCellViewModel
    var city : String
    var latitude : Double
    var longitude : Double
    var address : String
    @Binding var animView : Bool

    var body: some View {
        ZStack {
            MapActiveView(city: city, latitude: latitude, longitude: longitude)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            DesignImage.closeBlack.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(.trailing, 20)
                        }
                        Spacer()
                    }
                    .padding(.top, 52)
                    .onTapGesture {
                        withAnimation {
                            self.animView.toggle()
                        }
                    }
                }
            VStack{
                Spacer()
                LocationInfoView(city: city, address: address)
                    .background(ThemeColors.whiteGray.color)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                
            }
        }
        .ignoresSafeArea()
    }
}

//struct MapInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapInfoView(story: storyCellViewModel(story: storyList[0]), animView: .constant(false))
//    }
//}
