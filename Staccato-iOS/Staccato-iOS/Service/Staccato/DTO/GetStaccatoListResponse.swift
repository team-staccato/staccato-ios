//
//  GetStaccatoListResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

struct GetStaccatoListResponse: Decodable {
    
    let staccatoLocationResponses: [StaccatoLocationResponse]
    
}

struct StaccatoLocationResponse: Decodable {
    
    let staccatoId: Int64
    
    let latitude: Double
    
    let longitude: Double
    
}
