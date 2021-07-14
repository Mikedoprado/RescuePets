//
//  ContentView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/15/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var auth : AuthenticationModel
    
    var body: some View {
        ZStack {
//            TestingThings()
            if auth.isSignedIn{
                HomeMapView(imageData: Data(), mapData: Data())
            }else{
                Authentication()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




