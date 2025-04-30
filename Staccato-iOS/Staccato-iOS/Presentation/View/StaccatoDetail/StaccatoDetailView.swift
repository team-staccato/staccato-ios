//
//  StaccatoDetailView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

import Kingfisher

struct StaccatoDetailView: View {
    
    // MARK: - State Properties
    
    let staccatoId: Int64
    
    @ObservedObject var viewModel: StaccatoDetailViewModel
    
    @State var commentText: String = ""
    @FocusState private var isCommentFocused: Bool

    @State private var isStaccatoModifySheetPresented = false

    init(_ staccatoId: Int64) {
        self.staccatoId = staccatoId
        self.viewModel = StaccatoDetailViewModel()
        viewModel.getStaccatoDetail(staccatoId)
    }
    
    
    // MARK: - UI Properties
    
    private let horizontalInset: CGFloat = 16

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        imageSlider
                        
                        titleLabel
                        
                        Divider()
                        
                        locationSection
                        
                        Divider()
                        
                        feelingSection
                        
                        Divider()
                        
                        commentSection
                            .id("commentSection")
                    }
                }
                .onChange(of: viewModel.comments) { _,_ in
                    if viewModel.shouldScrollToBottom {
                        withAnimation {
                            proxy.scrollTo("commentSection", anchor: .bottom)
                            viewModel.shouldScrollToBottom = false
                        }
                    }
                }
                .onTapGesture {
                    isCommentFocused = false
                }
            }
            
            Spacer()
            
            commentTypingView
        }
        .staccatoNavigationBar {
            Button("수정") {
                isStaccatoModifySheetPresented = true
            }

            Button("삭제") {
                // TODO: 삭제 기능 구현
            }
        }

        .sheet(isPresented: $isStaccatoModifySheetPresented) {
            StaccatoCreateView(category: nil)
        }
    }
}


// MARK: - UI Components

private extension StaccatoDetailView {
    
    var imageSlider: some View {
        ImageSliderWithDot(
            images: viewModel.staccatoDetail?.staccatoImageUrls ?? [],
            imageWidth: ScreenUtils.width,
            imageHeight: ScreenUtils.width
        )
        .padding(.bottom, 7)
    }
    
    var titleLabel: some View {
        Text(viewModel.staccatoDetail?.staccatoTitle ?? "")
            .typography(.title1)
            .foregroundStyle(.staccatoBlack)
            .lineLimit(.max)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, horizontalInset)
    }
    
    var locationSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.staccatoDetail?.placeName ?? "")
                .typography(.body1)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
            
            Text(viewModel.staccatoDetail?.address ?? "")
                .typography(.body4)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
            
            let visitedAt: String = viewModel.staccatoDetail?.visitedAt ?? ""
            let visitedAtString: String = {
                guard visitedAt.count >= 10 else { return "" }
                let year = visitedAt.prefix(4)
                let month = visitedAt.dropFirst(5).prefix(2)
                let day = visitedAt.dropFirst(8).prefix(2)
                
                return "\(year)년 \(month)월 \(day)일"
            }()
            Text("\(visitedAtString)에 방문했어요")
                .typography(.body2)
                .foregroundStyle(.staccatoBlack)
                .padding(.top, 20)
        }
        .padding(.horizontal, horizontalInset)
    }

    var feelingSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("이 때의 기분은 어땠나요?")
                .typography(.title2)
                .foregroundStyle(.staccatoBlack)
            
            HStack {
                ForEach(FeelingType.allCases, id: \.id) { feeling in
                    Button {
                        let previousFeeling = viewModel.selectedFeeling
                        viewModel.selectedFeeling = feeling == viewModel.selectedFeeling ? nil : feeling
                        viewModel.postStaccatoFeeling(viewModel.selectedFeeling) { isSuccess in
                            if !isSuccess {
                                viewModel.selectedFeeling = previousFeeling
                            }
                        }
                        
                    } label: {
                        feeling.image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .opacity(viewModel.selectedFeeling == feeling ? 1 : 0.3)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, horizontalInset)
    }
    
    
    var commentSection: some View {
        VStack(alignment: .leading) {
            Text("코멘트")
                .typography(.title2)
                .foregroundStyle(.staccatoBlack)
            
            Group {
                if viewModel.comments.isEmpty {
                    VStack(spacing: 10) {
                        Image(.staccatoCharacter)
                        
                        Text("코멘트가 없어요! 코멘트를 달아보세요.")
                            .typography(.body2)
                            .foregroundStyle(.staccatoBlack)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 11)
                    .padding(.bottom, 28)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.comments, id: \.commentId) { comment in
                            makeCommentView(userId: viewModel.userId, comment: comment)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 22)
                }
            }
        }
        .padding(.horizontal, horizontalInset)
    }
    
    var commentTypingView: some View {
        let placeholder = "코멘트 입력하기"
        
        return HStack(spacing: 6) {
            TextField("", text: $commentText)
                .textFieldStyle(StaccatoTextFieldStyle())
                .overlay(alignment: .topLeading) {
                    if !isCommentFocused && commentText.isEmpty {
                        Text(placeholder)
                            .padding(12)
                            .typography(.body1)
                            .foregroundStyle(.gray3)
                    }
                }
                .focused($isCommentFocused)
            
            Button {
                viewModel.postComment(commentText)
                commentText.removeAll()
            } label: {
                Image(StaccatoIcon.arrowRightCircleFill)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(commentText.isEmpty ? .gray3 : .accent)
                    .frame(width: 30, height: 30)
            }
            .disabled(commentText.isEmpty)
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
    
}


// MARK: - UI Generator

private extension StaccatoDetailView {
    
    func makeCommentView(userId: Int64, comment: CommentModel) -> some View {
        
        // properties
        let isFromUser: Bool = userId == comment.memberId
        
        var nicknameText: some View {
            Text(comment.nickname)
                .typography(.body4)
                .foregroundStyle(.staccatoBlack)
        }
        
        var profileImage: some View {
            if let imageUrl = comment.memberImageUrl {
                let image = KFImage(URL(string: imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.circle)
                    .frame(width: 38, height: 38)
                return AnyView(image)
            } else {
                let image = Image(.personCircleFill)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.gray2)
                    .clipShape(.circle)
                    .frame(width: 38, height: 38)
                return AnyView(image)
            }
        }
        
        var commentView: some View {
            let corners: UIRectCorner = {
                if isFromUser {
                    return [.topLeft, .bottomLeft, .bottomRight]
                } else {
                    return [.topRight, .bottomLeft, .bottomRight]
                }
            }()
            
            return ZStack {
                Rectangle()
                    .foregroundStyle(.gray1)
                    .clipShape(RoundedCornerShape(corners: corners, radius: 10))
                
                Text(comment.content)
                    .typography(.body3)
                    .foregroundStyle(.staccatoBlack)
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
        
        // actual comment view
        return Group {
            if isFromUser {
                HStack(alignment: .top, spacing: 6) {
                    VStack(alignment: .trailing, spacing: 6) {
                        nicknameText
                        commentView
                    }
                    profileImage
                }
                .padding(.leading, 24)
            } else {
                HStack(alignment: .top, spacing: 6) {
                    profileImage
                    VStack(alignment: .leading, spacing: 6) {
                        nicknameText
                        commentView
                    }
                }
                .padding(.trailing, 24)
            }
        }
        .contextMenu {
            Button {
                // TODO: 댓글 수정 UI 요청
            } label: {
                Text("수정")
                Image(StaccatoIcon.pencilLine)
            }
            
            Button {
                // TODO: 댓글 삭제 경고 Alert 커스텀
                viewModel.deleteComment(comment.commentId)
            } label: {
                Text("삭제")
                Image(StaccatoIcon.trash)
            }
            .foregroundStyle(.red)
        }
    }
    
}
