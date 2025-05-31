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
                if let image = invitation.inviteeProfileImageUrl {
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
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
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            Divider()
        }
        
    }
}
