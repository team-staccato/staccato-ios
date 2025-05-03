//
//  StaccatoModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

// MARK: - Model

struct StaccatoDetailModel: Identifiable, Equatable {
    
    let id: UUID
    
    let staccatoId: Int64
    let categoryId: Int64
    let categoryTitle: String
    let startAt: String?
    let endAt: String?
    let staccatoTitle: String
    let staccatoImageUrls: [String]
    let visitedAt: String
    let feeling: String
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
    
}


// MARK: - Initializer

extension StaccatoDetailModel {
    
    init(from dto: GetStaccatoDetailResponse) {
        self.id = UUID()
        self.staccatoId = dto.staccatoId
        self.categoryId = dto.categoryId
        self.categoryTitle = dto.categoryTitle
        self.startAt = dto.startAt
        self.endAt = dto.endAt
        self.staccatoTitle = dto.staccatoTitle
        self.staccatoImageUrls = dto.staccatoImageUrls
        self.visitedAt = dto.visitedAt
        self.feeling = dto.feeling
        self.placeName = dto.placeName
        self.address = dto.address
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
    
}
