//
//  MapViewController.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 21/05/2024.
//

import UIKit
import MapKit
class MapViewController: UIViewController, CLLocationManagerDelegate,
                         MKMapViewDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    var mapData = [Place]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        mapView.showsUserLocation = true
        distanceLabel.isHidden = true
        mapView.isZoomEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetMap))
    }
    @objc func resetMap(){
        distanceLabel.isHidden = true
        mapView.removeOverlays(mapView.overlays)
        guard let userLocation = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        distanceLabel.isHidden = true
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
                DispatchQueue.main.async {
                    self.updateMapAnnotations()
                }
            } else {
                print("Failed to fetch places.")
            }
        }
        for place in mapData {
            createPlaceAnnotation(place: place)
        }
        
        
    }
    
    func createPlaceAnnotation(place: Place){
        
        let placelocation = CLLocation(latitude: place.location.latitude, longitude: place.location.longitude)
        let location2D : CLLocationCoordinate2D = CLLocationCoordinate2DMake(placelocation.coordinate.latitude, placelocation.coordinate.longitude)
        
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = location2D
        anotation.title = place.displayName.text
        anotation.subtitle = String(place.rating ?? 0)
        
        mapView.addAnnotation(anotation)
        
        
    }
    
    func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for place in mapData {
            createPlaceAnnotation(place: place)
        }
    }
    // MARK: -  MapView delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationCoordinate = view.annotation?.coordinate else { return }
        createRoute(to: annotationCoordinate)
    }

    func createRoute(to destinationCoordinate: CLLocationCoordinate2D) {
        guard let userLocation = locationManager.location?.coordinate else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }


    
}
