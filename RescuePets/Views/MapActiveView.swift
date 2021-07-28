//
//  MapActiveView.swift
//  RescuePets
//
//  Created by Michael do Prado on 7/15/21.
//


import SwiftUI
import MapKit



struct MapActiveView: View {
    
    var story : StoryCellViewModel
    
    @State var region : MKCoordinateRegion

    init(story: StoryCellViewModel, latitude: Double, longitude: Double) {
        self.story = story
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.020, longitudeDelta: 0.020))
    }
    
    func getPlace(story: StoryCellViewModel) -> Place {
        let place = Place(name: story.city, latitude: story.latitude, longitude: story.longitude
        )
        return place
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [getPlace(story: story)]) { place in
            MapMarker(coordinate: place.coordinate)
        }
        .ignoresSafeArea(.all)
    }
}

