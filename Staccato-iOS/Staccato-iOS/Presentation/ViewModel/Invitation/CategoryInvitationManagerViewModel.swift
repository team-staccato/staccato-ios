//
//  CategoryInviteManagerViewModel.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/22/25.
//

import Foundation
import SwiftUI

class CategoryInvitationManagerViewModel: ObservableObject {
    @Published var receivedInvitaions: [ReceivedInvitationModel] = []
    @Published var sentInvitaions: [SentInvitationModel] = []
}

extension CategoryInvitationManagerViewModel {
    @MainActor
    func fetchReceivedInvites() {
        Task {
            do {
                let invitationList = try await STService.shared.invitationService.getReceivedInvites()
                let invitations = invitationList.invitations.map { ReceivedInvitationModel(from: $0) }
                
                withAnimation {
                    self.receivedInvitaions = invitations
                }
            } catch {
                print("❌ 에러 발생: \(error)")
            }
        }
        
    }
    
    @MainActor
    func fetchSentInvites() {
        Task {
            do {
                let invitationList = try await STService.shared.invitationService.getSentInvites()
                let invitations = invitationList.invitations.map { SentInvitationModel(from: $0) }
                
                withAnimation {
                    self.sentInvitaions = invitations
                }
            } catch {
                print("❌ 에러 발생: \(error)")
            }
        }
    }
    
    @MainActor
    func acceptInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.acceptInvite(invitationId)
            fetchReceivedInvites()
        }
    }
    
    @MainActor
    func rejectInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.rejectInvite(invitationId)
            fetchReceivedInvites()
        }
    }
    
    @MainActor
    func cancelInvite(_ invitationId: Int64) {
        Task {
            try await STService.shared.invitationService.cancelInvite(invitationId)
            fetchSentInvites()
        }
    }
}
