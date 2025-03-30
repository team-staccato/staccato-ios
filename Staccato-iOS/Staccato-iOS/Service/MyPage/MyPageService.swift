//
//  MyPageService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Foundation

protocol MyPageServiceProtocol {
    
    func getProfile() async throws -> GetProfileResponse
    
    func uploadProfileImage(_ requestBody: PostProfileImageRequest) async throws -> ImageURL
    
}

class MyPageService: MyPageServiceProtocol {
    
    func getProfile() async throws -> GetProfileResponse {
        guard let profile = try await NetworkService.shared.request(
            endpoint: MyPageEndpoint.getProfile,
            responseType: GetProfileResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return profile
    }
    
    func uploadProfileImage(_ requestBody: PostProfileImageRequest) async throws -> ImageURL {
        let response = try await NetworkService.shared.uploadImage(requestBody.image)
        return response
    }

}
