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

    @Published var cameraPosition: GMSCameraPosition?

    @Published var isStaccatoListPresented: Bool = false
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
        for staccatoId in staccatoIds {
            guard let marker = displayedMarkers[staccatoId] else {
                print("⚠️ Marker not found for staccato ID: \(staccatoId)")
                continue
            }

            marker.icon = colorType.markerImage
            updateMarkerUserData(marker, newColorType: colorType)
        }
    }

    /// 마커 위치 업데이트
    func updateMarkersPosition(for staccatoId: Int64, to coordinate: CLLocationCoordinate2D) {
        guard let marker = displayedMarkers[staccatoId] else {
            print("⚠️ Marker not found for staccato ID: \(staccatoId)")
            return
        }

        marker.position = coordinate
        updateMarkerUserData(marker, newCoordinate: coordinate)
    }

    private func updateMarkerUserData(
        _ marker: GMSMarker,
        newColorType: CategoryColorType? = nil,
        newCoordinate: CLLocationCoordinate2D? = nil
    ) {
        var userData = marker.userData as? StaccatoCoordinateModel

        if let newColor = newColorType {
            userData?.staccatoColor = newColor
        }

        if let newCoordinate = newCoordinate {
            userData?.latitude = newCoordinate.latitude
            userData?.longitude = newCoordinate.longitude
        }

        marker.userData = userData
    }

}
