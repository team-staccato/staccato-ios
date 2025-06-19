//
//  CategoryInviteManagerViewModel.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/22/25.
//

import Foundation
import SwiftUI

@MainActor
final class CategoryInvitationManagerViewModel: ObservableObject {
    
    @Published var receivedInvitaions: [ReceivedInvitationModel] = []
    @Published var sentInvitaions: [SentInvitationModel] = []

    func fetchReceivedInvitations() {
        Task {
            do {
                let invitationList = try await STService.shared.invitationService.getReceivedInvitations()
                let invitations = invitationList.invitations.map { ReceivedInvitationModel(from: $0) }
                
                withAnimation {
                    self.receivedInvitaions = invitations
                }
            } catch {
                print("❌ 에러 발생: \(error)")
            }
        }
        
    }
    
    func fetchSentInvitations() {
        Task {
            do {
                let invitationList = try await STService.shared.invitationService.getSentInvitations()
                let invitations = invitationList.invitations.map { SentInvitationModel(from: $0) }
                
                withAnimation {
                    self.sentInvitaions = invitations
                }
            } catch {
                print("❌ 에러 발생: \(error)")
            }
        }
    }
    
    func acceptInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.postAcceptInvitation(invitationId)
            fetchReceivedInvitations()
        }
    }
    
    func rejectInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.postRejectInvitation(invitationId)
            fetchReceivedInvitations()
        }
    }
    
    func cancelInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.postCancelInvitation(invitationId)
            fetchSentInvitations()
        }
    }
}
