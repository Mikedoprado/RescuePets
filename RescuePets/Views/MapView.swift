//
//  MapView.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//
import Foundation
import UIKit
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
//    @Binding var thumbImage : Image
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let annotationView = views.first {
                if let annotation = annotationView.annotation{
                    if annotation is MKUserLocation {
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapView.setRegion(region, animated: true)
                        print(annotation.coordinate.latitude, annotation.coordinate.latitude)
                        
                    }
                }
            }
        }
        
        func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
            
             let render = UIGraphicsImageRenderer(size: mapView.bounds.size)
             let ratio = mapView.bounds.size.height / mapView.bounds.size.width
             let img = render.image { (ctx) in
                 mapView.drawHierarchy(in: CGRect(x: 100, y: 100, width: 300, height: 300 * ratio), afterScreenUpdates: true)
             }
             DispatchQueue.main.async {
//                self.control.thumbImage = Image(uiImage: img)
             }
        }
        
    }
    
}

