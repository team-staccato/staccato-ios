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
    var markedStaccatos: [StaccatoCoordinateModel] = []
    var notMarkedStaccatos: [StaccatoCoordinateModel] {
        let newStaccatos = staccatoCoordinates.filter { newStaccato in
            !markedStaccatos.contains { presentedStaccato in
                presentedStaccato.id == newStaccato.id
            }
        }
        return newStaccatos
    }
    
    @Published var isfetchingStaccatoList = false
    
    let locationManager = CLLocationManager()
    var isInitialCameraMove: Bool = true
    
    
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
                        id: UUID(),
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
