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
                                lineWidth: 4
                            )
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    }
                }
            
            HStack(spacing: 0) {
                if member.memberRole == .host {
                    Image(.crown)
                        .resizable()
                        .foregroundStyle(Color.staccatoBlue)
                        .frame(width: 8, height: 6)
                        .padding(.trailing, 2)
                }
                
                Text("\(member.nickname)")
                    .font(StaccatoFont.body5.font)
                    .foregroundStyle(Color.staccatoBlack)
                    .frame(maxWidth: 50)
                    .lineLimit(1)
            }
        }
    }
}
