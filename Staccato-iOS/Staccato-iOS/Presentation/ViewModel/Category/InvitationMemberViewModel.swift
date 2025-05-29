//
//  InvitationMemberViewModel.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/21/25.
//

import Foundation
import Combine
import Kingfisher

@MainActor
final class InvitationMemberViewModel: ObservableObject {
    
    private let categoryId: Int64?
    @Published var selectedMembers: [SearchedMemberModel] = []
    @Published var searchMembers: [SearchedMemberModel] = []
    
    var nameSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    
    init(_ categoryId: Int64?) {
        self.categoryId = categoryId
        bind()
    }
    
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
    
    private func bind() {
        nameSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { self.getSearchedMember($0) }
            .store(in: &cancellables)
    }
}

extension InvitationMemberViewModel {
    func getSearchedMember(_ name: String) {
        searchMembers.removeAll()
        if name == "" { return }
        
        Task {
            let response = try await MemberService.getSearchMemberList(name)
            response.members.forEach {
                var searchedMember = SearchedMemberModel(from: $0)
                if selectedMembers.contains(searchedMember) { searchedMember.isSelected = true }
                searchMembers.append(searchedMember)
            }
        }
    }
    
    // TODO: - 초대 후 상태 보여주기 필요
    // TODO: - category 예외처리??
    func postInvitationMember() {
        guard let categoryId else { return }
        Task {
            try await InvitationService.postInvitationMember(categoryId, selectedMembers.map { $0.id })
        }
    }
}
