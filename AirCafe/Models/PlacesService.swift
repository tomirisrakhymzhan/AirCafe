//
//  PlacesService.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 04/06/2024.
//
import Foundation
import CoreLocation

class PlacesService {
    static let shared = PlacesService()
    private var data: [Place] = []

    private init() {}

    func fetchNearbyPlaces(numOfPlaces: Int, radius: Int, currentLocation: CLLocation, completion: @escaping ([Place]?) -> Void) {
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude

        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            print("Error: Google Places API_KEY key not found in environment variables")
            completion(nil)
            return
        }

        let urlString = "https://places.googleapis.com/v1/places:searchNearby"
        guard let url = URL(string: urlString) else {
            print("Error creating URL")
            completion(nil)
            return
        }

        let parameters: [String: Any] = [
            "includedTypes": ["restaurant", "cafe", "bar"],
            "maxResultCount": numOfPlaces,
            "rankPreference": "distance",
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": currentLatitude,
                        "longitude": currentLongitude
                    ],
                    "radius": radius
                ]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error serializing JSON")
            completion(nil)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
        urlRequest.setValue("places.name,places.location,places.displayName,places.formattedAddress,places.types,places.priceLevel,places.rating,places.regularOpeningHours.openNow,places.regularOpeningHours.weekdayDescriptions", forHTTPHeaderField: "X-Goog-FieldMask")
        urlRequest.httpBody = jsonData

        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                completion(nil)
                return
            }


            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let placesResponse = try decoder.decode(PlacesResponse.self, from: data)
                    // Use the 'places' array here
                    self.data = placesResponse.places
                    completion(placesResponse.places)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            } else {
                print("No data received.")
                completion(nil)
            }
        }

        task.resume()
    }

    func getPlaces() -> [Place] {
        return self.data
    }
}
