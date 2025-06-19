//
//  CategoryInviteManagerView.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/18/25.
//

import SwiftUI

struct CategoryInvitationManagerView: View {
    
    @EnvironmentObject private var viewModel: CategoryInvitationManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var alertManager = StaccatoAlertManager()
    @State private var selectedType: InvitationType = .received
    
    var body: some View {
        ZStack {
            VStack {
                
                navigationBar
                
                typeSwitchButtons
                
                Spacer()
                
                if viewModel.receivedInvitaions.isEmpty && selectedType == .received
                    || viewModel.sentInvitaions.isEmpty && selectedType == .sent {
                    emptyStateView
                } else {
                    invitationList
                }
                
                Spacer()
            }
            
            if alertManager.isPresented {
                StaccatoAlertView(alertManager: $alertManager)
            }
        }
        .toolbarBackgroundVisibility(.hidden)
        .onAppear {
            viewModel.fetchReceivedInvitations()
            viewModel.fetchSentInvitations()
        }
    }
}

private extension CategoryInvitationManagerView {
    var navigationBar: some View {
        ZStack {
            HStack(spacing: 0) {
                Button  {
                    dismiss()
                } label: {
                    Image(.chevronLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.leading, 16)
                        .foregroundStyle(.gray3)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text("카테고리 초대 관리")
                    .typography(.title2)
                    .foregroundStyle(.gray5)
                
                Spacer()
            }
        }
        .frame(height: 56)
    }
    
    var typeSwitchButtons: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.staccatoWhite)
                    .frame(width: (geometry.size.width - 60) / 2, height: 44)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .offset(x: selectedType == .received ? -(geometry.size.width - 32) * 0.25 : (geometry.size.width - 32) * 0.25)
                    .animation(.easeInOut(duration: 0.3), value: selectedType)
                
                HStack(spacing: 6) {
                    inviteTypeButton(type: .received, text: "받은 초대", icon: "tray.and.arrow.down")
                    inviteTypeButton(type: .sent, text: "보낸 초대", icon: "paperplane.fill")
                }
            }
            .background(.gray1)
            .cornerRadius(7)
            .padding(.horizontal, 16)
        }
        .frame(height: 54)
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
            .foregroundColor(selectedType == type ? .staccatoBlue : .gray3)
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
                        onReject: {
                            alertManager.show(
                                .confirmCancelAlert(
                                    title: "정말 거절하시겠습니까?",
                                    message: "친구가 실망할지도 몰라요!") {
                                        viewModel.rejectInvite(invite.id)
                                    }
                            )
                        },
                        onAccept: { viewModel.acceptInvite(invite.id) }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            } else {
                ForEach(viewModel.sentInvitaions) { invite in
                    SentInvitationCell(invitation: invite) {
                        alertManager.show(
                            .confirmCancelAlert(
                                title: "정말 취소하시겠습니까?",
                                message: "취소하더라도 나중에 다시 초대를 보낼 수 있어요.") {
                                    viewModel.cancelInvite(invite.id)
                                }
                        )
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
    var emptyStateView: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(.staccatoCharacter)
            let text = selectedType == .received ?
            "아직 친구에게 받은 초대가 없어요!" :
            "보낸 초대가 없어요!\n카테고리에서 친구를 초대해보세요."
            Text(text) .typography(.body4)
                .foregroundStyle(.gray3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 11)
        .padding(.bottom, 28)
    }
}

private extension CategoryInvitationManagerView {
    enum InvitationType {
        case received
        case sent
    }
}

#Preview {
    NavigationStack {
        CategoryInvitationManagerView()
            .environmentObject(CategoryInvitationManagerViewModel())
    }
}
