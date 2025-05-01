//
//  CreateStaccatoRequest 2.swift
//  Staccato-iOS
//
//  Created by 정승균 on 5/1/25.
//


struct CreateStaccatoRequest: Encodable {
    var staccatoTitle: String
    var placeName: String
    var address: String
    var latitude, longitude: Double
    var visitedAt: String
    var categoryID: Int64
    var staccatoImageUrls: [String]
}