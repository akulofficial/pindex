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


struct MapView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager()
//    let lc:CLLocationCoordinate2D = LocationManager.locationManager.location!.coordinate

    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
//    func makeUIView(context: UIViewRepresentableContext<MapView>) ->
//        MapView.Type; as? MapView.Type {
//        MKMapView(frame: .zero)
//    }

    func updateUIView(_ view: MKMapView, context: Context) {
        //let coordinate = locationManager.$lastLocation //CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868)
        
//        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
//
//              currentLocation = locManager.location
//
//        }
//
//        // checking to see if we are authorized to use the user's location
//        if (locationManager.locationStatus) {
//
//        }
        
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
