//
//  Place.swift
//  RescuePets
//
//  Created by Michael do Prado on 10/26/21.
//

import Foundation
import MapKit

struct Place : Identifiable{
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
