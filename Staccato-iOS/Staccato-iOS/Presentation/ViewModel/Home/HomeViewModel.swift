//
//  HomeViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {

    // MARK: - Properties

    @Published var staccatoCoordinates: [StaccatoCoordinateModel] = []
    var presentedStaccatos: [StaccatoCoordinateModel] = []

    @Published var isfetchingStaccatoList = false

}


// MARK: - Network

@MainActor
extension HomeViewModel {

    func fetchStaccatos() {
        Task {
            guard !isfetchingStaccatoList else {
                print("🥑 is Loading staccatos")
                return
            }
            isfetchingStaccatoList = true
            
            defer {
                self.isfetchingStaccatoList = false
            }
            
            do {
                let staccatoList = try await STService.shared.staccatoService.getStaccatoList()
                
                let locations: [StaccatoCoordinateModel] = staccatoList.staccatoLocationResponses.map {
                    StaccatoCoordinateModel(
                        staccatoId: $0.staccatoId,
                        latitude: $0.latitude,
                        longitude: $0.longitude
                    )
                }
                
                self.staccatoCoordinates = locations
            } catch {
                print("Error fetching staccatos: \(error.localizedDescription)")
            }
        }
    }

}
