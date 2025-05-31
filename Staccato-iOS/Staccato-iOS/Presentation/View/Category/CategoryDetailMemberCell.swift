//
//  CategoryDetailMemberCell.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/24/25.
//

import SwiftUI
import Kingfisher

struct CategoryDetailMemberCell: View {
    let member: CategoryDetailModel.MemberModel
    
    var body: some View {
        VStack(spacing: 7) {
            KFImage(URL(string: member.memberImageUrl ?? ""))
                .fillPersonImage(width: 45, height: 45)
                .overlayIf(member.memberRole == .host) {
                    ZStack {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.staccatoBlue, Color.staccatoBlue20],
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                ),
                                lineWidth: 3
                            )
                            .padding(-1.5)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    }
                }
                .padding(.horizontal, 3)
            
            HStack(spacing: 2) {
                if member.memberRole == .host {
                    Image(.crown)
                        .resizable()
                        .frame(width: 8, height: 6)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.staccatoBlue)
                }
                
                Text("\(member.nickname)")
                    .font(StaccatoFont.body5.font)
                    .foregroundStyle(Color.staccatoBlack)
                    .lineLimit(1)
            }
            .frame(maxWidth: 65)
        }
    }
}
