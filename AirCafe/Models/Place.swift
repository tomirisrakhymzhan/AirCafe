//
//  Place.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 23/05/2024.
//

import Foundation
struct PlacesResponse: Codable {
    let places: [Place]
}

struct Place: Codable {
    let name: String
    let types: [String]
    let formattedAddress: String
    let location: Location
    let rating: Double?
    let regularOpeningHours: RegularOpeningHours?
    let priceLevel: String?
    let displayName: DisplayName
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct RegularOpeningHours: Codable {
    let openNow: Bool
    let weekdayDescriptions: [String]
}

struct DisplayName: Codable {
    let text: String
    let languageCode: String
}

//struct PlaceResponse: Codable {
//    let places: [Place]
//}
//
//// Ensure all properties in Place and its nested structs match the JSON structure
//struct Place: Codable {
//    let name: String
//    let types: [String]
//    let formattedAddress: String
//    let location: Location
//    let rating: Double
//    let regularOpeningHours: RegularOpeningHours?
//    let priceLevel: String?
//    let displayName: DisplayName
//}
//
//// Ensure all properties in nested structs match the JSON structure
//struct Location: Codable {
//    let latitude: Double
//    let longitude: Double
//}
//
//struct RegularOpeningHours: Codable {
//    let openNow: Bool
//    let weekdayDescriptions: [String]
//}
//
//struct DisplayName: Codable {
//    let text: String
//    let languageCode: String
//}
