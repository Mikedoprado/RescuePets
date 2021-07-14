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
    
    
    @Binding var thumbImage : Image
    @Binding var mapData : Data?
    let map = MKMapView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
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
            if fullyRendered {
                takePicture()
            }
        }
        
        func takePicture(){
            
            let options = MKMapSnapshotter.Options()
            options.region = control.map.region
            options.size = CGSize(width: control.map.frame.width, height: control.map.frame.width)
            options.scale = 2

            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { [weak self] (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Snapshot error: \(String(describing: error))")
                    return
                }
                guard let strongSelf = self else {return}
                let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let image = snapshot.image
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.draw(at: CGPoint.zero)
                
                let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
                for annotation in strongSelf.control.map.annotations {
                    var point = snapshot.point(for: annotation.coordinate)
                    if visibleRect.contains(point) {
                        point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                        point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                        pin.image?.draw(at: point)
                    }
                }
                
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                if let imagePointer = compositeImage, let data = imagePointer.jpegData(compressionQuality: 0.8){
                    self?.control.thumbImage = Image(uiImage: imagePointer)
                    self?.control.mapData = data
                    
                }
            }
        }
    }
    
}

