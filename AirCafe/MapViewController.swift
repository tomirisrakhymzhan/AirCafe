//
//  MapViewController.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 21/05/2024.
//

import UIKit
import MapKit
class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    var mapData = [Place]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Requesting location authorization")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("Location access denied. Please enable in Settings.")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted. Starting location updates.")
            locationManager.startUpdatingLocation()
        default:
            print("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Set map's visible region to include user location
        guard let location = locations.last else {
            return
        }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
        
        PlacesService.shared.fetchNearbyPlaces(numOfPlaces: 10, radius: 1000, currentLocation: location) { places in
            if let places = places {
                print("Fetched places: \(places)")
                self.mapData = places
            } else {
                print("Failed to fetch places.")
            }
        }
        
        for place in mapData {
            let lat:CLLocationDegrees = place.location.latitude
            let long:CLLocationDegrees = place.location.latitude
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            let anotation = MKPointAnnotation()
            
            anotation.coordinate = location
            anotation.title = place.displayName.text
            anotation.subtitle = String(place.rating ?? 0.0)
            mapView.addAnnotation(anotation)
            
        }
        
    }

    
}
