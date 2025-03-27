//
//  StaccatoDetailViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/27/25.
//

import Foundation

class StaccatoDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var staccatoDetail: StaccatoDetailModel?
    @Published var selectedFeeling: FeelingType?
    let userId: Int64 = AuthTokenManager.shared.getUserId() ?? -1
    
}


// MARK: - Network

extension StaccatoDetailViewModel {
    
    @MainActor
    func fetchStaccatoDetail(_ staccatoId: Int64) {
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
                
                print("🥑 staccatoDetail.id: \(staccatoDetail.id)")
                
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
    
}
