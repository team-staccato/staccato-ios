//
//  InvitationService.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

protocol InvitationServiceProtocol {
    func getReceivedInvitations() async throws -> GetReceivedInvitaionsResponse
    func getSentInvitations() async throws -> GetSentInvitationsResponse
    func postAcceptInvitation(_ invitationId: Int64) async throws
    func postRejectInvitation(_ invitationId: Int64) async throws
    func postCancelInvitation(_ invitationId: Int64) async throws
}

struct InvitationService {
    @discardableResult
    static func postInvitationMember(_ categoryId: Int64, _ membersId: [Int64]) async throws -> PostInvitationsResponse {
        guard let response = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.postInvitations(categoryId, membersId),
            responseType: PostInvitationsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return response
    }
    
    func getReceivedInvitations() async throws -> GetReceivedInvitaionsResponse {
        guard let invitations = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.getReceivedInvitations,
            responseType: GetReceivedInvitaionsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return invitations
    }
    
    func getSentInvitations() async throws -> GetSentInvitationsResponse {
        guard let invitations = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.getSentInvitations,
            responseType: GetSentInvitationsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return invitations
    }
    
    func postAcceptInvitation(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.postAcceptInvitation(invitationId)
        )
    }
    
    func postRejectInvitation(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.postRejectInvitation(invitationId)
        )
    }
    
    func postCancelInvitation(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.postCancelInvitation(invitationId)
        )
    }
}
