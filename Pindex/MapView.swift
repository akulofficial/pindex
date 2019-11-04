//
//  Map.swift
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


// Global variables necessary to center the user's location once the map has been opened
var mStruct:Map? // used as a global variable to reference the current Map Struct
var mStructView:MKMapView? // the view for mStruct
var mStructContext:Map.Context? // the context associated with mStruct
var needToCenterLocation:Bool = true // will be true when the map needs to be centered on the user's location

var currentBulletinBoard:String = "B Board" // is the current bulletin board that the user is viewing


struct MapView: View {

    @State var pins: [MapPin] = addPins()
    @State var selectedPin: MapPin?
    @State var action: Int? = 0 // used to force navigation link to "be tapped"

    var body: some View {
        
        NavigationView {
            VStack {
                Map(pins: $pins, selectedPin: $selectedPin)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                if selectedPin != nil {
                    //Text(verbatim: "Welcome to \(selectedPin?.title ?? "???")!")
                    Text("")
                    .opacity(0.0)
                    .onAppear(perform: {self.action = 1})
                }
                
                
                NavigationLink(destination: BulletinBoardView(mapAction: $action), tag: 1, selection: $action) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Find Bulletins")
            .onAppear(perform: {self.action = 0}) // resetting so that the user may tap the annotation again
            .onDisappear(perform: {self.selectedPin = nil}) // resetting so that the user may tap the bulletin again and it is not already selected
        
        }
 
    } // end of body

} // end of MapView

/*
struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bool: Binding<Bool>(get: { globalBool }, set: { globalBool = $0 }))
    }
}
*/

// adds the hardcoded pins into an array
func addPins() -> [MapPin] {
    
    var pins:[MapPin] = []
    
    let p1 = MapPin(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "AKUL", subtitle: "NEW SUB", action: {
        print("FOUND AKUL")
        currentBulletinBoard = "akul"
    })
    let p2 = MapPin(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "18th avenue library", subtitle: "NEW SUB", action: {
        print("FOUND SWETHA")
        currentBulletinBoard = "18th avenue library"
    })
    db.collection("Location").document("akul").getDocument {
        (document, error) in
        if let document = document, document.exists {
            p1.coordinate = CLLocationCoordinate2D(latitude: document.get("latitude")! as! Double, longitude: document.get("longitude")! as! Double)
        } else {
            print("Document does not exist")
        }
    }
    db.collection("Location").document("18th ave library").getDocument {
          (document, error) in
          if let document = document, document.exists {
              p2.coordinate = CLLocationCoordinate2D(latitude: document.get("latitude")! as! Double, longitude: document.get("longitude")! as! Double)
          } else {
              print("Document does not exist")
          }
      }
    pins.append(p1)
    pins.append(p2)
    
    return pins
       
} // end of addPins()



// The MAP struct which holds a view and will be passed to our MapView
struct Map: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {

        @Binding var selectedPin: MapPin?

        init(selectedPin: Binding<MapPin?>) {
            _selectedPin = selectedPin
        }

        func mapView(_ mapView: MKMapView,
                     didSelect view: MKAnnotationView) {
            guard let pin = view.annotation as? MapPin else {
                return
            }
            pin.action?()
            selectedPin = pin
        }

        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            guard (view.annotation as? MapPin) != nil else { // the pin was selected
                return
            }
            selectedPin = nil
        }
    } // end of Coordinator Class

    @Binding var pins: [MapPin]
    @Binding var selectedPin: MapPin?

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedPin: $selectedPin)
    }

    func makeUIView(context: Context) -> MKMapView {
        needToCenterLocation = true
        let view = MKMapView(frame: .zero)
        mStructView = view
        mStructContext = context
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        print("Updated UIView (Map)")
        mStruct = self

        // Showing region of map and adding user location
        var center = locationManager.lastLocation?.coordinate
        if (center == nil) {
            center = CLLocationCoordinate2D(latitude: 40, longitude: -82)
        }
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: center!, span: span)
        uiView.setRegion(region, animated: true)
        uiView.showsUserLocation = true
        
        // Adding annotations
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(pins)
        if let selectedPin = selectedPin {
            uiView.selectAnnotation(selectedPin, animated: false)
        }

    } // end of updateUIView()

} // end of struct Map

class MapPin: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let action: (() -> Void)?

    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         action: (() -> Void)? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

} // end of class MapPin

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
} // end of LocationManager Class

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString + "\n")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, "\(location)\n")
        
        // updating the map view to fit the user's location
        if (mStructView != nil && mStructContext != nil && needToCenterLocation == true) {
            
            needToCenterLocation = false
            
            // Showing region of map and adding user location
            var center = mStruct?.locationManager.lastLocation?.coordinate
            if (center == nil) {
                center = CLLocationCoordinate2D(latitude: 45, longitude: 55)
            }
            mStructView!.setCenter(center!, animated: true)
            
        } // end of if
        
    }

} // end of extension LocationManager

/*
struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map(pins: <#Binding<[MapPin]>#>, selectedPin: <#Binding<MapPin?>#>)
            .edgesIgnoringSafeArea(.top)
    }
}
*/
