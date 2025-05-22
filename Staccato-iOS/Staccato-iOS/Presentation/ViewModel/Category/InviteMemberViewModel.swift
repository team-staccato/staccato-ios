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
    // TODO: - 쓰레기값 ~ 없애버려 ~
    @Published var selectedMembers: [SearchedMemberModel] = [SearchedMemberModel(id: 1, nickname: "빙티", imageURL: ""),
                                                             SearchedMemberModel(id: 2, nickname: "해나이름짱긴어쩌고저쩌고", imageURL: ""),
                                                             SearchedMemberModel(id: 3, nickname: "빙티2", imageURL: ""),
                                                             SearchedMemberModel(id: 4, nickname: "빙티3", imageURL: ""),
                                                             SearchedMemberModel(id: 5, nickname: "빙티4", imageURL: ""),
                                                             SearchedMemberModel(id: 6, nickname: "빙티5", imageURL: ""),
                                                             SearchedMemberModel(id: 7, nickname: "빙티6", imageURL: ""),
                                                             SearchedMemberModel(id: 8, nickname: "빙티7", imageURL: "")]
    @Published var searchMembers: [SearchedMemberModel] = [SearchedMemberModel(id: 11, nickname: "영미1", imageURL: ""),
                                                           SearchedMemberModel(id: 12, nickname: "영미2", imageURL: "", isInvited: true),
                                                           SearchedMemberModel(id: 13, nickname: "영미3", imageURL: ""),
                                                           SearchedMemberModel(id: 14, nickname: "영미4", imageURL: ""),
                                                           SearchedMemberModel(id: 15, nickname: "영미5", imageURL: ""),
                                                           SearchedMemberModel(id: 16, nickname: "영미6", imageURL: ""),
                                                           SearchedMemberModel(id: 17, nickname: "영미7", imageURL: ""),
                                                           SearchedMemberModel(id: 18, nickname: "영미8", imageURL: "")]
    
    // 멤버 선택 토글 메서드
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
    
    // selectedListView에서 X 버튼 클릭 시 호출할 메서드
    func removeMemberFromSelected(_ member: SearchedMemberModel) {
        selectedMembers.removeAll(where: { $0.id == member.id })
        if let index = searchMembers.firstIndex(where: { $0.id == member.id }) {
            searchMembers[index].isSelected = false
        }
    }
}
