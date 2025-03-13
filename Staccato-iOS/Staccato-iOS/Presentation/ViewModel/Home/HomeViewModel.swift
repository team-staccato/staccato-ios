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
        STService.shared.staccatoService.getStaccatoList { [weak self] response in
            guard let self = self else {
                print("🥑 self is nil")
                return
            }
            
            guard !isfetchingStaccatoList else {
                print("🥑 is Loading staccatos")
                return
            }
            
            isfetchingStaccatoList = true
            
            let locations: [StaccatoCoordinateModel] = response.staccatoLocationResponses.map {
                StaccatoCoordinateModel(
                    staccatoId: $0.staccatoId,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
            
            DispatchQueue.main.async {
                self.staccatoCoordinates = locations
                self.isfetchingStaccatoList = false
            }
        }
    }
    
}
