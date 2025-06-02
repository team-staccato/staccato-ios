//
//  ReceivedInviteCell.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/20/25.
//

import SwiftUI

struct ReceivedInvitationCell: View {
    let invitation: ReceivedInvitationModel
    let onReject: () -> Void
    let onAccept: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 0) {
                            if let profileImageUrl = invitation.inviterProfileImageUrl,
                               let url = URL(string: profileImageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .padding(.trailing, 3)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 16, height: 16)
                                            .padding(.trailing, 3)
                                    case .failure:
                                        Image(.personCircleFill)
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.gray2)
                                            .frame(width: 16, height: 16)
                                            .padding(.trailing, 3)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(.personCircleFill)
                                    .resizable()
                                    .foregroundStyle(.gray2)
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .padding(.trailing, 3)
                            }
                            Text("\(invitation.inviterNickname)")
                                .bold()
                                .foregroundColor(.staccatoBlack)
                                .typography(.title3)

                            Text("님이 카테고리에 초대했어요.")
                                .foregroundColor(.staccatoBlack)
                                .typography(.title3)
                        }
                        Text(invitation.categoryTitle)
                            .typography(.body4)
                            .foregroundColor(.staccatoBlack)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            onReject()
                        }) {
                            Text("거절")
                                .typography(.body5)
                                .foregroundColor(.staccatoBlack)
                        }
                        .foregroundColor(.staccatoBlack)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray2, lineWidth: 1)
                        )
                        .buttonStyle(.plain)
                        Button(action: {
                            onAccept()
                        }) {
                            Text("수락")
                                .typography(.body5)
                                .foregroundColor(.staccatoWhite)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.staccatoBlue)
                        .cornerRadius(8)
                        .buttonStyle(.plain)
                    }
                }
            }
            
            Divider()
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(Color.white)
    }
}
