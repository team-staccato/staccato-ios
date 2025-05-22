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
    let staccatoColor: String
    let latitude: Double
    let longitude: Double

}


// MARK: - Mapping: DTO -> Model

extension StaccatoCoordinateModel {

    init(from dto: StaccatoLocationResponse) {
        self.id = dto.staccatoId
        self.staccatoId = dto.staccatoId
        self.staccatoColor = dto.staccatoColor
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }

}
