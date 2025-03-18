//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

protocol StaccatoServiceProtocol {
    
    func getStaccatoList() async throws -> GetStaccatoListResponse
    
}

class StaccatoService: StaccatoServiceProtocol {
    
    func getStaccatoList() async throws -> GetStaccatoListResponse {
        guard let staccatoList = try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.getStaccatoList,
            responseType: GetStaccatoListResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return staccatoList
    }
    
}
