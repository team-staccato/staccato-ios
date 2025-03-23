//
//  MyPageService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Foundation

protocol MyPageServiceProtocol {
    
    func getProfile() async throws -> GetProfileResponse
    
}

class MyPageService: MyPageServiceProtocol {
    
    func getProfile() async throws -> GetProfileResponse {
        guard let staccatoList = try await NetworkService.shared.request(
            endpoint: MyPageEndpoint.getProfile,
            responseType: GetProfileResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return staccatoList
    }
}
