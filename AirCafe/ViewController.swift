//
//  ViewController.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 15/05/2024.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacesTarget

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 390
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: PlaceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PlaceTableViewCell.identifier)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: CLLocationManagerDelegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
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
        guard let location = locations.first else { return }
        print("User coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        PlacesService.shared.fetchNearbyPlaces(numOfPlaces: 20, radius: 5000, currentLocation: location) { places in
            if let places = places {
                print("Fetched places: \(places)")
                self.dataSource = places
            } else {
                print("Failed to fetch places.")
            }
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as! PlaceTableViewCell
        let place = dataSource[indexPath.row]
        cell.setupUI(place: place)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = storyboard!
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        print(detailVC.description)
        detailVC.place = dataSource[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
}
