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
        VStack(spacing: 4) {
            KFImage(URL(string: member.memberImageUrl ?? ""))
                .fillPersonImage(width: 40, height: 40)
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
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                    }
                }
            
            Text("\(member.nickname)")
                .font(StaccatoFont.body5.font)
                .foregroundStyle(Color.staccatoBlack)
                .frame(width: 50)
                .lineLimit(1)
        }
    }
}
