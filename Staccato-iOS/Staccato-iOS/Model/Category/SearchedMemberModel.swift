//
//  Member.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/21/25.
//

import Foundation

struct SearchedMemberModel: Identifiable, Equatable {
    
    let id: Int
    let nickname: String
    let imageURL: String
    var isSelected: Bool = false
    var isInvited: Bool = false
    
    init(id: Int, nickname: String, imageURL: String, isSelected: Bool = false, isInvited: Bool = false) {
        self.id = id
        self.nickname = nickname
        self.imageURL = imageURL
        self.isSelected = isSelected
        self.isInvited = isInvited
    }
}
