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
    
    let userId: Int64 = AuthTokenManager.shared.getUserId() ?? -1
    
}


// MARK: - Network

extension StaccatoDetailViewModel {
    
    @MainActor
    func getStaccatoDetail(_ staccatoId: Int64) {
        Task {
            do {
                let response = try await STService.shared.staccatoService.getStaccatoDetail(staccatoId)
                
                let staccatoDetail = StaccatoDetailModel(
                    id: UUID(),
                    staccatoId: response.staccatoId,
                    categoryId: response.categoryId,
                    categoryTitle: response.categoryTitle,
                    startAt: response.startAt,
                    endAt: response.endAt,
                    staccatoTitle: response.staccatoTitle,
                    staccatoImageUrls: response.staccatoImageUrls,
                    visitedAt: response.visitedAt,
                    feeling: response.feeling,
                    placeName: response.placeName,
                    address: response.address,
                    latitude: response.latitude,
                    longitude: response.longitude
                )
                self.staccatoDetail = staccatoDetail
                self.selectedFeeling = FeelingType.from(serverKey: staccatoDetail.feeling)
            } catch {
                print("Error fetching staccato detail: \(error.localizedDescription)")
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
                let comment: [CommentModel] = try await STService.shared.commentService.getComments(staccatoDetail.staccatoId).comments.map {
                    CommentModel(
                        commentId: $0.commentId,
                        memberId: $0.memberId,
                        nickname: $0.nickname,
                        memberImageUrl: $0.memberImageUrl,
                        content: $0.content
                    )
                }
                self.comments = comment
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
    
}
