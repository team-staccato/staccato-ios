//
//  CategoryInviteManagerView.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/18/25.
//

import SwiftUI

import SwiftUI

struct CategoryInvitationManagerView: View {
    
    @EnvironmentObject private var viewModel: CategoryInvitationManagerViewModel
    
    @State private var selectedType: InvitationType = .received
    
    var body: some View {
        VStack {
            typeSwitchButtons
            Spacer()
            if viewModel.receivedInvitaions.isEmpty && selectedType == .received
                || viewModel.sentInvitaions.isEmpty && selectedType == .sent {
                emptyStateView()
            } else {
                invitationList
            }
            Spacer()
        }
        .onAppear {
            viewModel.fetchReceivedInvites()
            viewModel.fetchSentInvites()
        }
    }
}

private extension CategoryInvitationManagerView {
    var typeSwitchButtons: some View {
        HStack {
            HStack {
                inviteTypeButton(type: .received, text: "받은 초대", icon: "tray.and.arrow.down")
                inviteTypeButton(type: .sent, text: "보낸 초대", icon: "paperplane.fill")
            }
            .background(.gray1)
            .cornerRadius(8)
            .padding(.horizontal, 16)
        }
    }
    
    func inviteTypeButton(
        type: InvitationType,
        text: String,
        icon: String
    ) -> some View {
        Button {
            selectedType = type
        } label: {
            HStack(spacing: 6) {
                Text(text).typography(.title3)
                Image(systemName: icon)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(selectedType == type ? .staccatoWhite : .clear)
            .foregroundColor(selectedType == type ? .staccatoBlue : .gray3)
            .cornerRadius(8)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
    }
}


private extension CategoryInvitationManagerView {
    var invitationList: some View {
        List {
            if selectedType == .received {
                ForEach(viewModel.receivedInvitaions) { invite in
                    ReceivedInvitationCell(
                        invitation: invite,
                        onReject: { viewModel.rejectInvite(invite.id) },
                        onAccept: { viewModel.acceptInvite(invite.id) }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            } else {
                ForEach(viewModel.sentInvitaions) { invite in
                    SentInvitationCell(invitation: invite) {
                        viewModel.cancelInvite(invite.id)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.plain)
    }
}

private extension CategoryInvitationManagerView {
    func emptyStateView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            Image(.staccatoCharacter)
            switch selectedType {
            case .received:
                Text("아직 친구에게 받은 초대가 없어요!")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
            case .sent:
                Text("보낸 초대가 없어요!\n카테고리에서 친구를 초대해보세요.")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 11)
        .padding(.bottom, 28)
    }
}

enum InvitationType {
    case received
    case sent
}

#Preview {
    NavigationStack {
        CategoryInvitationManagerView()
    }
}
