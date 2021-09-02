//
//  MapInfoView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/16/21.
//

import SwiftUI

struct MapInfoView: View {

    @ObservedObject var story : StoryCellViewModel
    @Binding var animView : Bool

    var body: some View {
        ZStack {
            MapActiveView(story: story, latitude: story.latitude, longitude: story.longitude)
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            DesignImage.closeBlack.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(.trailing, 30)
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
                LocationInfoView(city: story.city, address: story.address)
                    .background(ThemeColors.whiteGray.color)
                    .cornerRadius(20)
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
