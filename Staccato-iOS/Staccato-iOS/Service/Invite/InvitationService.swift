//
//  InvitationService.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

struct InvitationService {
    static func postInvitationMember(_ categoryId: Int64, _ membersId: [Int64]) async throws -> PostInvitationsResponse {
        guard let response = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.postInvitations(categoryId, membersId),
            responseType: PostInvitationsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return response
    }
}
