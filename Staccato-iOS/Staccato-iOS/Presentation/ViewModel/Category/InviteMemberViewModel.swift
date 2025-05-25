//
//  InviteMemberViewModel.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/21/25.
//

import Foundation
import UIKit
import Kingfisher

final class InviteMemberViewModel: ObservableObject {
    
    @Published var selectedMembers: [SearchedMemberModel] = []
    @Published var searchMembers: [SearchedMemberModel] = []
    
    func toggleMemberSelection(_ member: SearchedMemberModel) {
        if let index = searchMembers.firstIndex(where: { $0.id == member.id }) {
            searchMembers[index].isSelected.toggle()
            if searchMembers[index].isSelected {
                selectedMembers.append(searchMembers[index])
            } else {
                selectedMembers.removeAll(where: { $0.id == member.id })
            }
        }
    }
    
    func removeMemberFromSelected(_ member: SearchedMemberModel) {
        selectedMembers.removeAll(where: { $0.id == member.id })
        if let index = searchMembers.firstIndex(where: { $0.id == member.id }) {
            searchMembers[index].isSelected = false
        }
    }
}
