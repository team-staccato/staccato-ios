//
//  StaccatoDetailViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/27/25.
//

import Foundation

class StaccatoDetailViewModel: ObservableObject {

    // MARK: - Properties

    @Published var staccatoDetail: StaccatoDetailModel? {
        didSet {
            Task { @MainActor in
                getComments()
            }
        }
    }
    @Published var selectedFeeling: FeelingType?
    @Published var comments: [CommentModel] = []
    @Published var shouldScrollToBottom: Bool = false

    @Published var shareLink: URL?

    let userId: Int64 = AuthTokenManager.shared.getUserId() ?? -1
    
}


// MARK: - Network

extension StaccatoDetailViewModel {

    @MainActor
    func getStaccatoDetail(_ staccatoId: Int64) {
        Task {
            do {
                let response = try await STService.shared.staccatoService.getStaccatoDetail(staccatoId)
                let staccatoDetail = StaccatoDetailModel(from: response)
                self.staccatoDetail = staccatoDetail
                self.selectedFeeling = FeelingType.from(serverKey: staccatoDetail.feeling)
            } catch {
                print("Error fetching staccato detail: \(error.localizedDescription)")
            }
        }
    }

    func delteStaccato(_ staccatoId: Int64) {
        Task {
            do {
                try await STService.shared.staccatoService.deleteStaccato(staccatoId)
            } catch {
                print("Error deleting staccato: \(error.localizedDescription)")
            }
        }
    }

    func postStaccatoFeeling(_ feeling: FeelingType?, isSuccess: @escaping ((Bool) -> Void)) {
        Task {
            do {
                guard let staccatoDetail = staccatoDetail else {
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

    @MainActor
    func getComments() {
        guard let staccatoDetail else {
            print("😢getComments - \(StaccatoError.optionalBindingFailed)")
            return
        }
        
        Task {
            do {
                let response: GetCommentsResponse = try await STService.shared.commentService.getComments(staccatoDetail.staccatoId)
                let comments: [CommentModel] = response.comments.map { CommentModel(from: $0) }
                self.comments = comments
            } catch {
                print("Error on getComments: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func postComment(_ content: String) {
        guard let staccatoDetail else { return }
        
        Task {
            do {
                try await STService.shared.commentService.postComment(
                    PostCommentRequest(staccatoId: staccatoDetail.staccatoId, content: content)
                )
                getComments()
                shouldScrollToBottom = true
            } catch {
                print("Error on postComment: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func updateComment(commentId: Int64, comment: String) {
        Task {
            do {
                try await STService.shared.commentService.putComment(
                    commentId,
                    PutCommentRequest(content: comment)
                )
                getComments()
            } catch {
                print("Error on putComment: \(error.localizedDescription)")
            }
        }
    }

    func deleteComment(_ commentId: Int64) {
        Task {
            do {
                try await STService.shared.commentService.deleteComment(commentId)
                await getComments()
            } catch {
                print("Error on deleteComment: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func postShareLink() {
        guard let staccatoId = staccatoDetail?.staccatoId else { return }
        Task {
            do {
                let shareLink: PostShareLinkResponse = try await STService.shared.staccatoService.postShareLink(staccatoId)
                self.shareLink = URL(string: shareLink.shareLink)
            } catch {
                print("❌ Error on postShareLink: \(error.localizedDescription)")
            }
        }
    }

}
