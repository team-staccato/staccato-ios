//
//  ImageService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 4/25/25.
//

import Foundation

protocol ImageServiceProtocol {
    
    func uploadImage(_ requestBody: PostImageRequest) async throws -> ImageResponse
    
    func uploadProfileImage(_ requestBody: PostImageRequest) async throws -> ProfileImageResponse
    
}

class ImageService: ImageServiceProtocol {
    func uploadImage(_ requestBody: PostImageRequest) async throws -> ImageResponse {
        guard let imageURL = try await NetworkService.shared.uploadImage(
            requestBody.image,
            endpoint: ImageEndPoint.uploadImage,
            responseType: ImageResponse.self
        )
        else {
            throw StaccatoError.optionalBindingFailed
        }
        return imageURL
    }
    
    
    func uploadProfileImage(_ requestBody: PostImageRequest) async throws -> ProfileImageResponse {
        guard let imageURL = try await NetworkService.shared.uploadImage(
            requestBody.image,
            endpoint: ImageEndPoint.uploadProfileImage,
            responseType: ProfileImageResponse.self
        )
        else {
            throw StaccatoError.optionalBindingFailed
        }
        return imageURL
    }

}

