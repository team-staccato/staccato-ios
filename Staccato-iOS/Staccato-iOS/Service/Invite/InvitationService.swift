//
//  InvitationService.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

protocol InvitationServiceProtocol {
    
    func postInvitationMember(_ categoryId: Int64, _ membersId: [Int64]) async throws -> PostInvitationsResponse
    
    func getReceivedInvites() async throws -> GetReceivedInvitaionsResponse
    
    func getSentInvites() async throws -> GetSentInvitationsResponse
    
    func acceptInvite(_ invitationId: Int64) async throws -> Void
    
    func rejectInvite(_ invitationId: Int64) async throws -> Void
    
    func cancelInvite(_ invitationId: Int64) async throws -> Void
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
    
    func getReceivedInvites() async throws -> GetReceivedInvitaionsResponse {
        guard let invitations = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.getReceivedInvites,
            responseType: GetReceivedInvitaionsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return invitations
    }
    
    func getSentInvites() async throws -> GetSentInvitationsResponse {
        guard let invitations = try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.getSentInvites,
            responseType: GetSentInvitationsResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return invitations
    }
    
    func acceptInvite(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.acceptInvite(invitationId)
        )
    }
    
    func rejectInvite(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.rejectInvite(invitationId)
        )
    }
    
    func cancelInvite(_ invitationId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: InvitationEndPoint.cancelInvite(invitationId)
        )
    }
}
