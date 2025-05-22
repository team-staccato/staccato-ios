//
//  InviteMemberView.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/20/25.
//

import SwiftUI
import Kingfisher

struct InviteMemberView: View {
    
    @EnvironmentObject private var viewModel: InviteMemberViewModel
    @Environment(\.dismiss) private var dismiss // TODO: - 고려 필요
    
    @State private var memberName: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            titleBarView
                .padding(.leading, 16)
                .padding([.top, .trailing], 18)
            
            searchBarView
                .padding(.top, 20)
                .padding([.leading, .trailing], 16)
                .presentationCornerRadius(5)
            
            Group {
                if !viewModel.selectedMembers.isEmpty {
                    selectedListView
                        .padding([.top, .leading], 16)
                }
                
                if !viewModel.searchMembers.isEmpty {
                    searchListView
                        .padding(.top, 17)
                }
            }
        }
    }
}

private extension InviteMemberView {
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
            
            Text("\(viewModel.selectedMembers.count)")
                .font(StaccatoFont.title3.font)
                .foregroundStyle(Color.staccatoBlue)
            
            Button {
                dismiss()
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
            
            TextField("닉네임을 검색해주세요.", text: $memberName)
                .foregroundStyle(Color.staccatoBlack)
        }
        .padding([.top, .bottom], 13)
        .padding(.leading, 17)
        .background(Color.gray1)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    var selectedListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(viewModel.selectedMembers) { member in
                    VStack(alignment: .center, spacing: 4) {
                        KFImage(URL(string: member.imageURL))
                            .placeholder {
                                Image(.personCircleFill)
                                    .resizable()
                                    .foregroundStyle(.gray2)
                                    .frame(width: 40, height: 40)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    withAnimation {
                                        viewModel.removeMemberFromSelected(member)
                                    }
                                } label: {
                                    Image(.xCircleFill)
                                        .foregroundColor(.gray5)
                                        .frame(width: 15, height: 15)
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
                    Divider()
                    
                    SearchMemberRow(member: member) { member in
                        viewModel.toggleMemberSelection(member)
                    }
                    .frame(height: 60)
                }
            }
        }
    }
}

struct SearchMemberRow: View {
    let member: SearchedMemberModel
    let onToggleSelection: (SearchedMemberModel) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: member.imageURL))
                .placeholder {
                    Image(.personCircleFill)
                        .resizable()
                        .foregroundStyle(.gray2)
                        .frame(width: 35, height: 35)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .padding(.leading, 16)
            
            Text("\(member.nickname)")
                .font(StaccatoFont.title3.font)
                .foregroundStyle(Color.staccatoBlack)
                .padding(.leading, 10)
            
            Spacer()
            
            if member.isInvited {
                Text("초대완료")
                    .font(StaccatoFont.body5.font)
                    .foregroundStyle(Color.gray3)
                    .padding(.trailing, 14)
            } else {
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
                                Image(.checkmark)
                                    .frame(width: 13, height: 13)
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
    InviteMemberView()
        .environmentObject(InviteMemberViewModel())
}
