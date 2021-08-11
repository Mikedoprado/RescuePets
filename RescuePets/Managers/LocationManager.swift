//
//  LocationManager.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import Foundation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        guard let location = locations.last else {
            return
        }
        if self.location != nil || self.location == location {
            return
        }
        self.location = location
        
        getAddressFromLatLon(pdblLatitude: String(location.coordinate.latitude), withLongitude: String(location.coordinate.longitude))
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {[weak self](placemarks, error) in
                    if (error != nil) || placemarks == nil 
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }else{
                        let pm = placemarks! as [CLPlacemark]

                        if pm.count > 0 {
                            let pm = placemarks![0]
                            var addressString : String = ""
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            if pm.subThoroughfare != nil {
                                addressString = addressString + pm.subThoroughfare!
                            }
                            self?.address = addressString
                            if pm.locality != nil {
                                self?.city = pm.locality!
                            }
                            if pm.country != nil {
                                self?.country = pm.country!
                            }
                      }
                    }
            })
        }
    
}
