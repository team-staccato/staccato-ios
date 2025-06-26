//
//  ReceivedInviteCell.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/20/25.
//

import SwiftUI
import Kingfisher

struct ReceivedInvitationCell: View {
    let invitation: ReceivedInvitationModel
    let onReject: () -> Void
    let onAccept: () -> Void
    
    var body: some View {
        VStack(spacing: 18) {
            content
                .padding(.horizontal, 22)
            
            Divider()
        }
        .padding(.vertical, 18)
    }

    private var content: some View {
        VStack(spacing: 8) {
            HStack {
                inviteInfo
                Spacer()
            }
            
            actionButtons
        }
    }

    private var inviteInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 5) {
                KFImage.url(URL(string: invitation.inviterProfileImageUrl ?? ""))
                    .fillPersonImage(width: 16, height: 16)
                
                Text(inviteCategoryString)
                    .foregroundColor(.staccatoBlack)
            }
            
            Text(invitation.categoryTitle)
                .typography(.title3)
                .foregroundColor(.staccatoBlack)
                .lineLimit(1)
        }
    }
    
    private var inviteCategoryString: AttributedString {
        var text = AttributedString("\(invitation.inviterNickname)님이 카테고리에 초대했어요.")
        if let inviter = text.range(of: "\(invitation.inviterNickname)") {
            text[inviter].font = StaccatoFont.body4.font.weight(.bold)
        }
        if let guide = text.range(of: "님이 카테고리에 초대했어요.") {
            text[guide].font = StaccatoFont.body4.font
        }
        
        return text
    }

    private var actionButtons: some View {
        HStack(spacing: 8) {
            Spacer()
            
            Button {
                onReject()
            } label: {
                Text("거절")
                    .typography(.body5)
                    .foregroundColor(.staccatoBlack)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray2, lineWidth: 0.5)
                    )
            }

            Button {
                onAccept()
            } label: {
                Text("수락")
                    .typography(.body5)
                    .foregroundColor(.staccatoWhite)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.staccatoBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ReceivedInvitationCell(
        invitation: ReceivedInvitationModel(
            id: 1,
            inviterId: 1,
            inviterNickname: "호혜연해나닉네임짱긴",
            inviterProfileImageUrl: nil,
            categoryId: 1,
            categoryTitle: "저기 사라진 별의 자리 아스라이 하얀 빛 한동안은 꺼내 볼 asdfasdfalsdkjfalksdjflkj"
        ), onReject: {}, onAccept: {})
}
