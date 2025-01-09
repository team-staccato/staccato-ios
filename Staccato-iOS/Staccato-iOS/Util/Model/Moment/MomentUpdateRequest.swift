//
//  MomentUpdateRequest.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MomentUpdateRequest: Codable {
    let staccatoTitle: String           // Staccato title
    let placeName: String               // Place name
    let address: String                 // Address
    let latitude: Double                // Latitude
    let longitude: Double               // Longitude
    let visitedAt: String               // Visited date and time
    let memoryId: Int64                 // Memory ID
    let momentImageUrls: [String]       // List of moment image URLs
}
