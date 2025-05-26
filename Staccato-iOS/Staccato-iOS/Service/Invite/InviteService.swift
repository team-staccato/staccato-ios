//
//  InviteService.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

struct InviteService {
    static func getSearchMemberList(_ name: String) async throws -> SearchMemberResponse {
        guard let memberList = try await NetworkService.shared.request(
            endpoint: InviteEndPoint.getSearchMemberList(name),
            responseType: SearchMemberResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return memberList
    }
    
    static func postInviteMember(_ categoryId: Int64, _ membersId: [Int64]) async throws -> PostInvitationsResponse {
        guard let response = try await NetworkService.shared.request(
            endpoint: InviteEndPoint.postInvitations(categoryId, membersId),
            responseType: PostInvitationsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return response
    }
}
