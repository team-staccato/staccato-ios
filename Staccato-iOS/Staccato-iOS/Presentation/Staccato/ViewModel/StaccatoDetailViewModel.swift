//
//  StaccatoDetailViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/27/25.
//

import Foundation

@MainActor
class StaccatoDetailViewModel: ObservableObject {

    // MARK: - Properties

    @Published var staccatoDetail: StaccatoDetailModel?
    @Published var selectedFeeling: FeelingType?
    @Published var comments: [CommentModel] = []
    @Published var shouldScrollToBottom: Bool = false

    @Published var shareLink: URL?

    let userId: Int64 = AuthTokenManager.shared.getUserId() ?? -1
    
}


// MARK: - Network

extension StaccatoDetailViewModel {

    func getStaccatoDetail(_ staccatoId: Int64) async throws {
        let response = try await STService.shared.staccatoService.getStaccatoDetail(staccatoId)
        let staccatoDetail = StaccatoDetailModel(from: response)
        self.staccatoDetail = staccatoDetail
        self.selectedFeeling = FeelingType.from(serverKey: staccatoDetail.feeling)
    }

    func deleteStaccato(_ staccatoId: Int64, isSuccess: @escaping ((Bool) -> Void)) {
        Task {
            do {
                try await STService.shared.staccatoService.deleteStaccato(staccatoId)
                isSuccess(true)
            } catch {
                print("Error deleting staccato: \(error.localizedDescription)")
                isSuccess(false)
            }
        }
    }

    func postStaccatoFeeling(_ feeling: FeelingType?, isSuccess: @escaping ((Bool) -> Void)) {
        Task.detached {
            do {
                guard let staccatoDetail = await self.staccatoDetail else {
                    print(StaccatoError.optionalBindingFailed, ": staccatoDetail")
                    return
                }
                let request = PostStaccatoFeelingRequest(feeling: feeling?.serverKey ?? FeelingType.nothing)
                try await STService.shared.staccatoService.postStaccatoFeeling(staccatoDetail.staccatoId, requestBody: request)
                isSuccess(true)
            } catch {
                print("❌ Failed to submit feeling: \(error)")
                isSuccess(false)
            }
        }
    }

    func getComments(_ staccatoId: Int64) async throws {
        let response: GetCommentsResponse = try await STService.shared.commentService.getComments(staccatoId)
        let comments: [CommentModel] = response.comments.map { CommentModel(from: $0) }
        self.comments = comments
    }

    func postComment(_ staccatoId: Int64, _ content: String) async throws {
        try await STService.shared.commentService.postComment(
            PostCommentRequest(staccatoId: staccatoId, content: content)
        )
    }

    func updateComment(commentId: Int64, comment: String) async throws {
        try await STService.shared.commentService.putComment(
            commentId,
            PutCommentRequest(content: comment)
        )
    }

    func deleteComment(_ commentId: Int64) async throws {
        try await STService.shared.commentService.deleteComment(commentId)
    }

    func postShareLink(_ staccatoId: Int64) async throws {
        let shareLink: PostShareLinkResponse = try await STService.shared.staccatoService.postShareLink(staccatoId)
        self.shareLink = URL(string: shareLink.shareLink)
    }

}
