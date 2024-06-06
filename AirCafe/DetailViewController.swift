//
//  DetailViewController.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 21/05/2024.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var priceLevelLabel: UILabel!
    
    @IBOutlet weak var openClosedLabel: UILabel!
    
    @IBOutlet weak var weekdayDescriptionLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var place : Place?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setupDetails()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        createPlaceAnnotation()

    }
    func setupDetails(){
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        guard let place = self.place else {
            print("No place annotation")
            return
        }
        var shownTypes = [String]()
        for type in place.types {
            if type != "point_of_interest" {
                shownTypes.append(type)
            }
        }
        var shownPriceLevel : String = "$$$" // by default
        switch place.priceLevel {
        case "PRICE_LEVEL_INEXPENSIVE":
            shownPriceLevel = "$"
        case "PRICE_LEVEL_MODERATE":
            shownPriceLevel = "$$"
        case "PRICE_LEVEL_EXPENSIVE":
            shownPriceLevel = "$$$"
        
        default:
            shownPriceLevel = "price level unknown"
        }
        
        if let regularOpeningHours = place.regularOpeningHours {
            if regularOpeningHours.openNow {
                openClosedLabel.text = "Open"
                openClosedLabel.textColor = .green
            } else {
                openClosedLabel.text = "Closed"
                openClosedLabel.textColor = .red
            }
            weekdayDescriptionLabel.text = regularOpeningHours.weekdayDescriptions.joined(separator: "\n")
        } else {
            openClosedLabel.text = "Open/Closed status unknown"
            openClosedLabel.textColor = .gray
            weekdayDescriptionLabel.text = "Weekday descriptions not available"
        }

        
        imageView.image = UIImage(named: "restaurant-default")
        titleLabel.text = place.displayName.text
        typeLabel.text = shownTypes.joined(separator: " | ")
        addressLabel.text = place.formattedAddress
        priceLevelLabel.text = shownPriceLevel
        //ratingLabel.text = String(place.rating ?? 0)
        weekdayDescriptionLabel.text = place.regularOpeningHours?.weekdayDescriptions.joined(separator: "/n")
    }
    func createPlaceAnnotation(){
        guard let place = self.place else {
            print("No place annotation")
            return
        }
        let placelocation = CLLocation(latitude: place.location.latitude, longitude: place.location.longitude)
        let location2D : CLLocationCoordinate2D = CLLocationCoordinate2DMake(placelocation.coordinate.latitude, placelocation.coordinate.longitude)
        
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = location2D
        anotation.title = place.displayName.text
        anotation.subtitle = String(place.rating ?? 0)
        
        mapView.addAnnotation(anotation)
        
    }


    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
