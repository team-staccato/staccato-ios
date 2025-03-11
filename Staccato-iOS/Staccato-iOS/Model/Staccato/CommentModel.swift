//
//  CommentModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

struct CommentModel {
    
    let commentId: Int64
    
    let memberId: Int64
    
    let nickname: String
    
    let memberImage: Image?
    
    let content: String
    
}


// TODO: 삭제

extension CommentModel {
    
    static let dummy: [CommentModel] = [
        CommentModel(
            commentId: 1,
            memberId: 1,
            nickname: "julie",
            memberImage: Image(.feelingHappy),
            content: "해물라면 존맛탱구리~ 카고가 편식을 했다. 오이를 다 뺐다. 딩초 카고."
        ),
        CommentModel(
            commentId: 2,
            memberId: 2,
            nickname: "Ruel",
            memberImage: nil,
            content: "바다 색깔이 너무 예뻤다. 빙티가 달려가다가 물에 빠져서 다같이 비웃어줬다ㅋㅋ 걸음마 다시 배우고 와라 빙빙"
        ),
        CommentModel(
            commentId: 3,
            memberId: 3,
            nickname: "gyunnie",
            memberImage: Image(.feelingScared),
            content: "안녕하세요 차은우 입니다. 많이 힘드시죠? 조금만 더 힘을 냅시다ㅎㅎ"
        )
    ]
    
}
