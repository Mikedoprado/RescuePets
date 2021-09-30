//
//  MapActiveView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/15/21.
//


import SwiftUI
import MapKit



struct MapActiveView: View {
    
//    @ObservedObject var story : StoryCellViewModel
    var latitude : Double
    var longitude : Double
    var city: String
    @State var region : MKCoordinateRegion

    init(city: String, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.020, longitudeDelta: 0.020))
    }
    
    func getPlace() -> Place {
        let place = Place(name: self.city, latitude: self.latitude, longitude: self.longitude
        )
        return place
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [getPlace()]) { place in
            MapMarker(coordinate: place.coordinate)
        }
        .ignoresSafeArea(.all)
    }
}

