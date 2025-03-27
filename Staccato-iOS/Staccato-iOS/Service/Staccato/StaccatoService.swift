//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

protocol StaccatoServiceProtocol {
    
    func getStaccatoList() async throws -> GetStaccatoListResponse
    
    func getStaccatoDetail(_ staccatoId: Int64) async throws -> GetStaccatoDetailResponse
    
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
    
    func getStaccatoDetail(_ staccatoId: Int64) async throws -> GetStaccatoDetailResponse {
        guard let staccatoDetail = try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.getStaccatoDetail(staccatoId),
            responseType: GetStaccatoDetailResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return staccatoDetail
    }
    
}
