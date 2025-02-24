//
//  StaccatoDetailView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

struct StaccatoDetailView: View {
    
    // MARK: - State Properties
    
    @State var staccato: StaccatoDetailModel = StaccatoDetailModel.sample
    
    @State var selectedFeeling: FeelingType? = nil
    
    // TODO: 수정
    @State var userId: Int64 = 1
    @State var comments: [CommentModel] = CommentModel.dummy
    
    @State var commentText: String = ""
    @FocusState private var isCommentFocused: Bool
    
    
    // MARK: - UI Properties
    
    private let horizontalInset: CGFloat = 16

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    imageTabView
                    
                    titleLabel
                    
                    Divider()
                    
                    locationSection
                    
                    Divider()
                    
                    feelingSection
                    
                    Divider()
                    
                    commentSection
                }
            }
            .onTapGesture {
                isCommentFocused = false
            }
            
            Spacer()
            
            commentTypingView
        }
        .staccatoNavigationBar {
            Button("수정") {
                // TODO: 수정 기능 구현
            }

            Button("삭제") {
                // TODO: 삭제 기능 구현
            }
        }
    }
}

#Preview("Preview - Empty") {
    StaccatoDetailView(staccato: StaccatoDetailModel.sample)
}


// MARK: - UI Components

private extension StaccatoDetailView {
    
    var imageTabView: some View {
        TabView {
            ForEach(staccato.momentImages.indices, id: \.self) { index in
                staccato.momentImages[index]
                    .resizable()
                    .scaledToFill()
                    .background(Color.gray2)
            }
        }
        .frame(width: ScreenUtils.width, height: ScreenUtils.width)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // TODO: 점이 이미지 아래에 있도록 커스텀
        .padding(.bottom, 10)
    }
    
    var titleLabel: some View {
        Text(staccato.memoryTitle)
            .typography(.title1)
            .foregroundStyle(.staccatoBlack)
            .lineLimit(.max)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, horizontalInset)
    }
    
    var locationSection: some View {
        VStack(alignment: .leading) {
            Text(staccato.placeName)
                .typography(.body1)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
            
            Text(staccato.address)
                .typography(.body4)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
            
            Text("\(staccato.visitedAt)에 방문했어요")
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
                        selectedFeeling = feeling == selectedFeeling ? nil : feeling
                        // TODO: 서버 POST
                        
                    } label: {
                        feeling.image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .opacity(selectedFeeling == feeling ? 1 : 0.3)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, horizontalInset)
    }
    
    
    var commentSection: some View {
        Group {
            if comments.isEmpty {
                VStack(spacing: 10) {
                    Image(.staccatoCharacter)
                    
                    Text("코멘트가 없어요! 코멘트를 달아보세요.")
                        .typography(.body2)
                        .foregroundStyle(.staccatoBlack)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 28)
            } else {
                VStack(spacing: 12) {
                    ForEach(comments, id: \.commentId) { comment in
                        makeCommentView(userId: userId, comment: comment)
                    }
                }
                .padding(.bottom, 22)
            }
        }
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
                print("버튼 클릭됨!")
                // TODO: 서버 통신
                commentText.removeAll()
            } label: {
                Image(commentText.isEmpty ? .arrowCircleRightDisabled : .arrowCircleRightEnabled)
                    .resizable()
                    .scaledToFit()
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
            let image = comment.memberImage ?? Image(.staccatoLoginLogo)
            return image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(.circle)
                .frame(width: 38, height: 38)
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
                .padding(.leading, 40)
                .padding(.trailing, horizontalInset)
            } else {
                HStack(alignment: .top, spacing: 6) {
                    profileImage
                    VStack(alignment: .leading, spacing: 6) {
                        nicknameText
                        commentView
                    }
                }
                .padding(.leading, horizontalInset)
                .padding(.trailing, 40)
            }
        }
    }
    
}
