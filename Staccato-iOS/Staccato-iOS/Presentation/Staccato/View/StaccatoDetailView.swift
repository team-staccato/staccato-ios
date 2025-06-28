//
//  StaccatoDetailView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI
import CoreLocation

import Kingfisher

struct StaccatoDetailView: View {
    
    // MARK: - State Properties
    
    let staccatoId: Int64
    @Environment(NavigationManager.self) var navigationManager
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var detentManager: BottomSheetDetentManager
    @StateObject private var viewModel = StaccatoDetailViewModel()
    
    @State private var alertManager = StaccatoAlertManager()
    @State var commentText: String = ""
    @State private var hasLoadedInitialData = false
    @State private var isStaccatoModifySheetPresented = false
    @FocusState private var isCommentFocused: Bool
    
    init(_ staccatoId: Int64) {
        self.staccatoId = staccatoId
    }
    
    // MARK: - UI Properties
    
    private let horizontalInset: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            imageSlider
                            
                            titleStack
                            
                            Divider()
                            
                            locationSection
                            
                            Divider()
                            
                            feelingSection
                            
                            Divider()
                            
                            commentSection
                            
                            Spacer()
                            
                            commentTypingView
                                .id("commentTypingView")
                        }
                    }
                    
                    if alertManager.isPresented {
                        StaccatoAlertView(alertManager: $alertManager)
                    }
                }
                .onChange(of: viewModel.comments) { _,_ in
                    DispatchQueue.main.async {
                        if viewModel.shouldScrollToBottom {
                            withAnimation {
                                proxy.scrollTo("commentTypingView", anchor: .bottom)
                                viewModel.shouldScrollToBottom = false
                            }
                        }
                    }
                }
                
                .onChange(of: isCommentFocused) { _, newValue in
                    if newValue {
                        detentManager.updateDetent(to: .large)
                    }
                    Task {
                        try await Task.sleep(for: .seconds(0.5))
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("commentTypingView", anchor: .bottom)
                        }
                    }
                }
                .onTapGesture {
                    isCommentFocused = false
                }
            }
            .staccatoNavigationBar {
                Button("수정") {
                    isStaccatoModifySheetPresented = true
                }
                
                Button("삭제") {
                    presentDeleteAlert()
                }
            }
            .onChange(of: viewModel.staccatoDetail) { _, _ in
                updateMapCamera()
            }
            .onChange(of: geometry.size.height) { _, height in
                detentManager.updateDetent(height)
            }
            .onAppear {
                detentManager.updateDetent(geometry.size.height)
                
                if !hasLoadedInitialData {
                    Task {
                        do {
                            try await viewModel.getStaccatoDetail(staccatoId)
                            try await viewModel.getComments(staccatoId)
                            try await viewModel.postShareLink(staccatoId)
                        } catch {
                            print("❌ Error: \(error.localizedDescription)")
                        }
                        
                        hasLoadedInitialData = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isStaccatoModifySheetPresented) {
                Task {
                    try await viewModel.getStaccatoDetail(staccatoId)
                }
            } content: {
                if let staccatoDetail = viewModel.staccatoDetail {
                    StaccatoEditorView(staccato: staccatoDetail)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}


// MARK: - Helper

private extension StaccatoDetailView {

    func presentDeleteAlert() {
        withAnimation {
            alertManager.show(
                .confirmCancelAlert(
                    title: "삭제하시겠습니까?",
                    message: "삭제를 누르면 복구할 수 없습니다") {
                        viewModel.deleteStaccato(staccatoId) {isSuccess in
                            if isSuccess,
                               let indexToRemove = homeViewModel.staccatos.firstIndex(where: { $0.id == staccatoId }) {
                                homeViewModel.staccatos.remove(at: indexToRemove)
                            }
                            navigationManager.dismiss()
                        }
                    }
            )
        }
    }
    
    func updateMapCamera() {
        if let detail = viewModel.staccatoDetail {
            let coordinate = CLLocationCoordinate2D(
                latitude: detail.latitude,
                longitude: detail.longitude
            )
            homeViewModel.moveCamera(to: coordinate)
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
    
    var titleStack: some View {
        HStack {
            Text(viewModel.staccatoDetail?.staccatoTitle ?? "")
                .typography(.title1)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)

            Spacer()

            shareButton
        }
        .padding(.horizontal, horizontalInset)
    }
    
    @ViewBuilder
    var shareButton: some View {
        if let link = viewModel.shareLink {
            ShareLink(item: link) {
                Image(StaccatoIcon.squareAndArrowUp)
                    .foregroundStyle(.gray3)
                    .fontWeight(.semibold)
                    .frame(width: 20, height: 20)
            }
        }
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
            
            HStack(spacing: (ScreenUtils.width - 40 - 255) / 4) {
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
                        feeling.colorImage
                            .resizable()
                            .frame(width: 51, height: 51)
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
                        Image(.staccatoCharacterGray)
                            .resizable()
                            .frame(width: 110, height: 110)
                        
                        Text("코멘트를 남겨보세요!")
                            .typography(.body4)
                            .foregroundStyle(.gray3)
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
            TextField("", text: $commentText, axis: .vertical)
                .focused($isCommentFocused)
                .textFieldStyle(StaccatoTextFieldStyle())
                .lineLimit(4)

                .overlay(alignment: .leading) {
                    if !isCommentFocused && commentText.isEmpty {
                        Text(placeholder)
                            .padding(.leading, 15)
                            .typography(.body2)
                            .foregroundStyle(.gray3)
                    }
                }

            commentSubmitButton
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, ScreenUtils.safeAreaInsets.bottom)
    }

    var commentSubmitButton: some View {
        let isValid = !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return Button {
            Task {
                do {
                    try await viewModel.postComment(staccatoId, commentText)
                    try await viewModel.getComments(staccatoId)
                    viewModel.shouldScrollToBottom = true
                    commentText.removeAll()
                } catch {
                    print("❌ Error: \(error.localizedDescription)")
                }
            }
        } label: {
            Image(StaccatoIcon.arrowRightCircleFill)
                .resizable()
                .scaledToFit()
                .foregroundStyle(isValid ? .staccatoBlue : .gray3)
                .frame(width: 30, height: 30)
        }
        .disabled(!isValid)
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
            KFImage(URL(string: comment.memberImageUrl ?? ""))
                .fillPersonImage(width: 38, height: 38)
        }

        var commentView: some View {
            let corners: UIRectCorner = [isFromUser ? .topLeft : .topRight, .bottomLeft, .bottomRight]

            return Text(comment.content)
                .typography(.body3)
                .foregroundStyle(.staccatoBlack)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedCornerShape(corners: corners, radius: 10)
                        .foregroundStyle(.gray1)
                )
        }

        // actual comment view
        return Group {
            if isFromUser {
                HStack(alignment: .top, spacing: 6) {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        nicknameText
                        commentView
                            .contextMenu {
                                // TODO: 댓글 수정 UI 요청
                                Button(role: .destructive) {
                                    alertManager.show(
                                        .confirmCancelAlert(
                                            title: "댓글을 삭제하시겠습니까?",
                                            message: "삭제하면 되돌릴 수 없어요") {
                                                Task {
                                                    do {
                                                        try await viewModel.deleteComment(comment.commentId)
                                                        try await viewModel.getComments(staccatoId)
                                                    } catch {
                                                        print("❌ Error: \(error.localizedDescription)")
                                                    }
                                                }
                                            }
                                    )
                                } label: {
                                    Label("삭제", systemImage: StaccatoIcon.trash.rawValue)
                                }
                            }
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
                    Spacer()
                }
                .padding(.trailing, 24)
            }
        }
    }
}
