//
//  HomeMapView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI

struct HomeMapView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var isShowPhotoLibrary = false
    @State private var image = Image("")
    @State private var inputImage: UIImage?
    @EnvironmentObject var auth: AuthenticationModel
    @State var selectedIndex = 0
    @State var shouldShowModal = false

    var tabBarItemInactive = [
        "iconNotify:Inactive",
        "iconCamera:Inactive",
        "iconMessage:Inactive",
        "iconProfile:Inactive"
    ]
    var tabBarItemActive = [
        "iconNotify:Active",
        "iconCamera:Active",
        "iconMessage:Active",
        "iconProfile:Active"
    ]
    
    var body: some View {
        ZStack{

            MapView()
                .ignoresSafeArea(.all)
            ThemeColors.black.color
                .opacity(0.4)
                .blendMode(.multiply)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                VStack {
                    HStack(alignment: .center){
                        ForEach(0..<4) { index in
                            Button(action: {
                                if index == 1 {
                                    shouldShowModal.toggle()
                                }
                                if index == 3 {
                                    self.auth.signOut()
                                }
                                selectedIndex = index
                            }, label: {
                                Spacer()
                                Image(uiImage: UIImage(named: selectedIndex == index ? (tabBarItemActive[index]) : (tabBarItemInactive[index]))!)
                                Spacer()
                            })
                        }
                    }
                }
                .frame(height: 100)
                .background(ThemeColors.white.color)
                .sheet(isPresented: $shouldShowModal, onDismiss: loadImage, content: {
                    ImagePicker(selectedImage: $inputImage)
                })
            }
            .ignoresSafeArea(edges: .bottom)
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        self.shouldShowModal = false
    }
}

struct HomeMapView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMapView()
    }
}
