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
    
    @Published var modalNavigationState = HomeModalNavigationState()
    
    @Published var staccatoCoordinates: [StaccatoCoordinateModel] = []
    var presentedStaccatos: [StaccatoCoordinateModel] = []
    
    @Published var isfetchingStaccatoList = false
    
    @Published var staccatoDetail: StaccatoDetailModel?
    
    let locationManager = CLLocationManager()
    
    
    // MARK: - Initialize
    
    init() {
        setLocationManager()
    }
    
}


// MARK: - Location

extension HomeViewModel {
    
    private func setLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }
    
    func updateLocationForOneSec() {
        locationManager.startUpdatingLocation()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.locationManager.stopUpdatingLocation() // 무한 호출 방지를 위해 0.1초 뒤 업데이트 멈춤
        }
    }
    
}


// MARK: - Network

extension HomeViewModel {
    
    func fetchStaccatos() {
        Task {
            await MainActor.run {
                guard !isfetchingStaccatoList else {
                    print("🥑 is Loading staccatos")
                    return
                }
                isfetchingStaccatoList = true
            }
            
            defer {
                Task { @MainActor in
                    self.isfetchingStaccatoList = false
                }
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
                
                await MainActor.run {
                    self.staccatoCoordinates = locations
                }
            } catch {
                print("Error fetching staccatos: \(error.localizedDescription)")
            }
        }
    }
    
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
                
                await MainActor.run {
                    self.staccatoDetail = staccatoDetail
                }
                
            } catch {
                print("Error fetching staccato detail: \(error.localizedDescription)")
            }
        }
    }
    
}
