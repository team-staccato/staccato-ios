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

    var staccatosToAdd: Set<StaccatoCoordinateModel> {
        staccatos.subtracting(displayedStaccatos)
    }
    var staccatosToRemove: Set<StaccatoCoordinateModel> {
        displayedStaccatos.subtracting(staccatos)
    }

    @Published var isfetchingStaccatoList = false

    @Published var cameraPosition: GMSCameraPosition?

    @Published var isStaccatoListPresented: Bool = false
    @Published var staccatoClusterList: [StaccatoCoordinateModel] = []

    func removeStaccatos(with staccatoIds: Set<Int64>) {
        staccatos = staccatos.filter { !staccatoIds.contains($0.staccatoId) }
    }

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
                
                let locations: [StaccatoCoordinateModel] = staccatoList.staccatoLocationResponses.map { StaccatoCoordinateModel(from: $0) }
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
            cameraPosition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        }
    }

}


// MARK: - Marker Updates

extension HomeViewModel {

    /// 마커 아이콘 업데이트
    func updateMarkerIcons(for staccatoIds: [Int64], to colorType: CategoryColorType) {
        var staccatosToRemove: Set<StaccatoCoordinateModel> = []
        var staccatosToAdd: Set<StaccatoCoordinateModel> = []

        for staccatoId in staccatoIds {
            guard var marker = displayedStaccatos.first(where: { $0.id == staccatoId }) else {
                print("⚠️ Marker not found for staccato ID: \(staccatoId)")
                continue
            }
            staccatosToRemove.insert(marker)
            marker.staccatoColor = colorType
            staccatosToAdd.insert(marker)
        }

        staccatos.subtract(staccatosToRemove)
        staccatos.formUnion(staccatosToAdd)
    }

    /// 마커 위치 업데이트
    func updateMarkersPosition(for staccatoId: Int64, to coordinate: CLLocationCoordinate2D) {
        guard var marker = displayedStaccatos.first(where: { $0.id == staccatoId }) else {
            print("⚠️ Marker not found for staccato ID: \(staccatoId)")
            return
        }

        staccatos.remove(marker)
        marker.latitude = coordinate.latitude
        marker.longitude = coordinate.longitude
        staccatos.insert(marker)
    }

}
