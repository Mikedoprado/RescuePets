//
//  ContentView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/15/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var auth = UserViewModel()

    @ViewBuilder var body: some View {
        ZStack {
            if auth.userRepository.isSignedIn{
//                HomeMapView()
                AppTabBarView()
            }else{
                Authentication()
            }
        }.environmentObject(auth)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




