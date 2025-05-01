//
//  HomeViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import SwiftUI
import CoreLocation

import GoogleMaps

class HomeViewModel: ObservableObject {

    // MARK: - Properties

    @Published var staccatos: Set<StaccatoCoordinateModel> = []
    var displayedStaccatos: Set<StaccatoCoordinateModel> = []
    var displayedMarkers: [Int64 : GMSMarker] = [:] // == [staccato.id : GMSMarker]

    var staccatosToAdd: Set<StaccatoCoordinateModel> {
        staccatos.subtracting(displayedStaccatos)
    }
    var staccatosToRemove: Set<StaccatoCoordinateModel> {
        displayedStaccatos.subtracting(staccatos)
    }

    @Published var isfetchingStaccatoList = false

    var isInitialCameraMove: Bool = true

    @Published var cameraPosition: GMSCameraPosition?

}


// MARK: - Network

@MainActor
extension HomeViewModel {

    func fetchStaccatos() {
        Task {
            guard !isfetchingStaccatoList else { return }
            isfetchingStaccatoList = true
            
            defer {
                self.isfetchingStaccatoList = false
            }
            
            do {
                let staccatoList = try await STService.shared.staccatoService.getStaccatoList()
                
                let locations: [StaccatoCoordinateModel] = staccatoList.staccatoLocationResponses.map {
                    StaccatoCoordinateModel(
                        id: $0.staccatoId,
                        staccatoId: $0.staccatoId,
                        latitude: $0.latitude,
                        longitude: $0.longitude
                    )
                }
                self.staccatos = Set(locations)
            } catch {
                print("Error fetching staccatos: \(error.localizedDescription)")
            }
        }
    }

}


// MARK: - Map

extension HomeViewModel {
    
    func moveCamera(to coordinate: CLLocationCoordinate2D, zoom: Float = 15.0) {
        withAnimation {
            cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 13)
        }
    }
    
}
