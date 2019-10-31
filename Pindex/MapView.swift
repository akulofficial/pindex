//
//  MapView.swift
//  Pindex
//
//  Created by Jake Taylor on 10/28/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation
import Combine
import Firebase
import FirebaseFirestore

struct MapView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager()

    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let akul = MKPointAnnotation()
        akul.title = "akul"
        //the zeros are dummy values
        akul.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        //lat and long are set using this section of code
        //TODO: Update this flow to use a method to update the coordinates of a MKPointAnnotation
        //TODO: Use a Firebase query to trigger the method so all annotations can be added to a view
        db.collection("Location").document("akul").getDocument {
            (document, error) in
            if let document = document, document.exists {
                akul.coordinate = CLLocationCoordinate2D(latitude: document.get("latitude")! as! Double, longitude: document.get("longitude")! as! Double)
            } else {
                print("Document does not exist")
            }
        }
        let map = MKMapView(frame: .zero)
        mapView(map, viewFor: akul)
        map.addAnnotation(akul)
        return map
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView;
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        var center = locationManager.lastLocation?.coordinate
        if (center == nil) {
            center = CLLocationCoordinate2D(latitude: 45, longitude: 55)
        }
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: center!, span: span)
        view.setRegion(region, animated: true)
        view.showsUserLocation = true
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .edgesIgnoringSafeArea(.top)
    }
}




// TESTING
// Location manager used for getting the user's current location
class LocationManager: NSObject, ObservableObject {

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, location)
    }

}
