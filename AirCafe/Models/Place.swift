//
//  Place.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 23/05/2024.
//

import Foundation
// MARK: - Welcome
struct Result: Codable {
    let places: [Place]
}

// MARK: - Place
struct Place: Codable {
    let name: String
    let types: [String]
    let formattedAddress: String
    let location: Location
    let rating: Double?
    let priceLevel: String?
    let displayName: DisplayName
}

// MARK: - DisplayName
struct DisplayName: Codable {
    let text, languageCode: String
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}
