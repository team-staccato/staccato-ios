//
//  ModifyStaccatoRequest.swift
//  Staccato-iOS
//
//  Created by 정승균 on 5/1/25.
//


struct PutStaccatoRequest: Encodable {
    var staccatoTitle: String
    var placeName: String
    var address: String
    var latitude, longitude: Double
    var visitedAt: String
    var categoryId: Int64
    var staccatoImageUrls: [String]
}
