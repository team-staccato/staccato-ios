//
//  CommentService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/25/25.
//

import Foundation

protocol CommentServiceProtocol {
    
    func getComments(_ staccatoId: Int64) async throws -> GetCommentsResponse
    
}

class CommentService: CommentServiceProtocol {
    
    func getComments(_ staccatoId: Int64) async throws -> GetCommentsResponse {
        guard let comments = try await NetworkService.shared.request(
            endpoint: CommentEndpoint.getComments(staccatoId),
            responseType: GetCommentsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return comments
    }
    
}
