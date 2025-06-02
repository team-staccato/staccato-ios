//
//  SentInviteCell.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/20/25.
//

import SwiftUI

struct SentInvitationCell: View {
    let invitation: SentInvitationModel
    let onCancel: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 12) {
                if let profileImageUrl = invitation.inviteeProfileImageUrl,
                   let url = URL(string: profileImageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        case .failure:
                            Image(.personCircleFill)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray2)
                                .frame(width: 40, height: 40)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(.personCircleFill)
                        .resizable()
                        .foregroundStyle(.gray2)
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                VStack(alignment: .leading) {
                    Text(invitation.inviteeNickname)
                        .typography(.title3)
                        .foregroundColor(.staccatoBlack)
                    HStack(spacing: 0) {
                        Text("\(invitation.categoryTitle)")
                            .bold()
                            .foregroundColor(.gray4)
                            .typography(.body4)

                        Text("에 초대했어요.")
                            .foregroundColor(.gray4)
                            .typography(.body4)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    onCancel()
                }) {
                    Text("취소")
                        .typography(.body5)
                        .foregroundColor(.staccatoWhite)
                        .padding(.vertical, 6)
                }
                .padding(.horizontal)
                .background(.staccatoRed)
                .cornerRadius(8)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            Divider()
        }
    }
}
