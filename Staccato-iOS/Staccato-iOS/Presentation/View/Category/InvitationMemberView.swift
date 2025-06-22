//
//  InvitationMemberView.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/20/25.
//

import SwiftUI
import Combine
import Kingfisher

struct InvitationMemberView: View {
    
    @State private var viewModel: InvitationMemberViewModel
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
    init(categoryId: Int64) {
        self.viewModel = InvitationMemberViewModel(categoryId)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            titleBarView
                .padding(.leading, 16)
                .padding([.top, .trailing], 18)
            
            searchBarView
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .presentationCornerRadius(5)
            
            if !viewModel.selectedMembers.isEmpty {
                selectedListView
                    .padding([.top, .horizontal], 16)
                
                Divider()
                    .padding(.top, 15)
            }
            
            if !viewModel.searchMembers.isEmpty {
                searchListView
            } else {
                staccatoEmptyView
                    .padding(.top, viewModel.selectedMembers.isEmpty ? 111 : 80)
            }
            
            Spacer()
        }
        .frame(height: 500)
        .background(.staccatoWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 180)
        .padding(.horizontal, 16)
        .dismissKeyboardOnGesture()
        .alert(viewModel.errorTitle ?? "", isPresented: $viewModel.catchError) {
            Button("확인") {
                viewModel.catchError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }
        .onChange(of: viewModel.inviteSuccess) { _, inviteSuccess in
            if inviteSuccess { dismiss() }
        }
    }
}

// MARK: - UI Components
private extension InvitationMemberView {
    var titleBarView: some View {
        HStack(spacing: 0) {
            Button("뒤로가기", systemImage: "xmark") {
                dismiss()
            }
            .foregroundStyle(Color.gray3)
            .labelStyle(.iconOnly)
            
            Spacer()
            
            Text("초대할 사람들")
                .font(StaccatoFont.title2.font)
                .foregroundStyle(Color.staccatoBlack)
            
            Spacer()
            
            if viewModel.selectedMembers.count > 0 {
                Text("\(viewModel.selectedMembers.count)")
                    .font(StaccatoFont.title3.font)
                    .foregroundStyle(Color.staccatoBlue)
            }
            
            Button {
                viewModel.postInvitationMember()
            } label: {
                Text("확인")
                    .font(StaccatoFont.body2.font)
                    .foregroundStyle(Color.staccatoBlack)
                    .padding(.leading, 4)
            }

        }
    }
    
    var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray3)
            
            TextField("닉네임을 검색해주세요.", text: $viewModel.memberName)
                .foregroundStyle(Color.staccatoBlack)
                .onChange(of: viewModel.memberName, initial: false) { _, name in
                    viewModel.memberName.trimPrefix(while: \.isWhitespace)
                }
            
            if viewModel.memberName != "" {
                Button {
                    viewModel.memberName = ""
                } label: {
                    Image(.xCircleFill)
                        .foregroundStyle(Color.gray3)
                        .frame(width: 15, height: 15)
                }
            }
        }
        .padding([.top, .bottom], 13)
        .padding(.leading, 17)
        .padding(.trailing, 15)
        .background(Color.gray1)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    var selectedListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(viewModel.selectedMembers) { member in
                    VStack(alignment: .center, spacing: 4) {
                        KFImage(URL(string: member.imageURL ?? ""))
                            .fillPersonImage(width: 40, height: 40)
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    withAnimation {
                                        viewModel.removeMemberFromSelected(member)
                                    }
                                } label: {
                                    Circle()
                                        .foregroundStyle(Color.gray5)
                                        .frame(width: 15, height: 15)
                                        .overlay {
                                            Image(.xmark)
                                                .resizable()
                                                .foregroundStyle(Color.staccatoWhite)
                                                .frame(width: 7, height: 7)
                                        }
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
        }
        .frame(height: 60)
    }
    
    var searchListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.searchMembers) { member in
                    SearchMemberRow(member: member) { member in
                        viewModel.toggleMemberSelection(member)
                    }
                    .frame(height: 60)
                    
                    Divider()
                }
            }
        }
    }
    
    var staccatoEmptyView: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("staccato_character_gray")
                .resizable()
                .frame(width: 110, height: 110)
            
            Text("친구를 초대해 함께 기록해보세요!")
                .font(StaccatoFont.body4.font)
                .foregroundStyle(Color.gray3)
        }
    }
}

struct SearchMemberRow: View {
    let member: SearchedMemberModel
    let onToggleSelection: (SearchedMemberModel) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: member.imageURL ?? ""))
                .fillPersonImage(width: 35, height: 35)
                .padding(.leading, 16)
            
            Text("\(member.nickname)")
                .font(StaccatoFont.title3.font)
                .foregroundStyle(Color.staccatoBlack)
                .padding([.leading, .trailing], 10)
                .lineLimit(1)
            
            Spacer()
            
            if member.status == .none {
                Button {
                    withAnimation {
                        onToggleSelection(member)
                    }
                } label: {
                    if member.isSelected {
                        Circle()
                            .fill(Color.gray2)
                            .frame(width: 27, height: 27)
                            .overlay {
                                Image(.icCheckmark)
                                    .resizable()
                                    .frame(width: 13, height: 10)
                                    .foregroundStyle(Color.staccatoBlack)
                            }
                            .padding(.trailing, 18)
                    } else {
                        Circle()
                            .fill(Color.white)
                            .stroke(Color.gray2, lineWidth: 1)
                            .frame(width: 27, height: 27)
                            .overlay {
                                Image(.plus)
                                    .frame(width: 13, height: 13)
                                    .foregroundStyle(Color.staccatoBlack)
                            }
                            .padding(.trailing, 18)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    InvitationMemberView(categoryId: 1)
}
