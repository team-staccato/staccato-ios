//
//  SentInviteCell.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/20/25.
//

import SwiftUI
import Kingfisher

struct SentInvitationCell: View {
    let invitation: SentInvitationModel
    let onCancel: () -> Void
    
    var body: some View {
        VStack {
            content
                .padding(.horizontal, 19)
                .padding(.vertical, 20)
            
            Divider()
        }
    }

    private var content: some View {
        HStack(alignment: .center, spacing: 10) {
            KFImage.url(URL(string: invitation.inviteeProfileImageUrl ?? ""))
                .fillPersonImage(width: 40, height: 40)
            
            invitationText
            
            Spacer()
            
            cancelButton
        }
    }

    private var invitationText: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(invitation.inviteeNickname)
                .typography(.title3)
                .foregroundColor(.staccatoBlack)
            
            HStack(spacing: 0) {
                Text(invitation.categoryTitle)
                    .font(StaccatoFont.body4.font.weight(.bold))
                    .foregroundColor(.gray4)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text("에 초대했어요.")
                    .font(StaccatoFont.body4.font)
                    .foregroundColor(.gray4)
                    .fixedSize()
            }
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            onCancel()
        }) {
            Text("취소")
                .typography(.body5)
                .foregroundColor(.staccatoWhite)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
        .background(.staccatoRed)
        .cornerRadius(5)
    }
}

// MARK: - Preview

#Preview {
    SentInvitationCell(
        invitation: SentInvitationModel(
            id: 1,
            inviteeId: 1,
            inviteeNickname: "호혜연해나닉네임짱긴",
            inviteeProfileImageUrl: nil,
            categoryId: 1,
            categoryTitle: "카테고리이름이너무길어서어떡하냐진짜제발짧게해"
        ), onCancel: {})
}
