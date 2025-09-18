//
//  StaccatoCoordinateModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

struct StaccatoCoordinateModel: Hashable {

    let id: Int64

    let staccatoId: Int64
    var staccatoColor: CategoryColorType
    var latitude: Double
    var longitude: Double
    var title: String
    var visitedAt: String

}


// MARK: - Mapping: DTO -> Model

extension StaccatoCoordinateModel {

    init(from dto: StaccatoLocationResponse) {
        self.id = dto.staccatoId
        self.staccatoId = dto.staccatoId
        self.staccatoColor = CategoryColorType.fromServerKey(dto.staccatoColor)
        self.latitude = dto.latitude
        self.longitude = dto.longitude
        self.title = dto.title
        self.visitedAt = dto.visitedAt
    }

}
