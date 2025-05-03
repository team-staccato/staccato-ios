//
//  MapViewControllerBridge.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct GMSMapViewRepresentable: UIViewRepresentable {

    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(NavigationState.self) var navigationState

    private let mapView = GMSMapView()

    func makeUIView(context: Context) -> GMSMapView {
        STLocationManager.shared.delegate = context.coordinator

        mapView.settings.myLocationButton = false // 우측아래 내위치 버튼 숨김
        mapView.isMyLocationEnabled = true // 내위치 파란점으로 표시
        mapView.delegate = context.coordinator
        
        // 초기 위치를 서울시청으로 함
        let seoulCityhall = CLLocationCoordinate2D(latitude: 37.5664056, longitude: 126.9778222)
        let camera = GMSCameraPosition.camera(withTarget: seoulCityhall, zoom: 13)
        mapView.camera = camera

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMarkers(to: uiView)

        if let cameraPosition = viewModel.cameraPosition {
            uiView.animate(to: cameraPosition)
        }
#if DEBUG
        print("GMSMapViewRepresentable updated")
#endif
    }

}


// MARK: - Coordinator

extension GMSMapViewRepresentable {

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject {
        let parent: GMSMapViewRepresentable
        
        init(_ parent: GMSMapViewRepresentable) {
            self.parent = parent
        }
    }

}


// MARK: - LocationManager Delegate

extension GMSMapViewRepresentable.Coordinator: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {
            print("❌ GMSMapView Location Optional Binding Failed")
            return
        }
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 13)
        parent.mapView.animate(to: camera)
    }

    // 위치 접근 권한 바뀔 때 파란 점 표시 여부 업데이트 및 현위치로 이동
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            parent.mapView.isMyLocationEnabled = true

            if let coordinate = manager.location?.coordinate {
                let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 13)
                parent.mapView.animate(to: camera)
            }
        } else {
            parent.mapView.isMyLocationEnabled = false
        }
    }

}


// MARK: - GMSMapView Delegate

extension GMSMapViewRepresentable.Coordinator: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let userdata = marker.userData as? StaccatoCoordinateModel {
            parent.navigationState.navigate(to: .staccatoDetail(userdata.staccatoId))
        } else {
            print("⚠️ No StaccatoData found for this marker.")
        }
        return false
    }

}


// MARK: - Private Methods

private extension GMSMapViewRepresentable {

    private func updateMarkers(to mapView: GMSMapView) {
        markStaccatos(to: mapView)
        removeMarkers(from: mapView)
    }

    /// 지도에 스타카토 마커를 추가합니다.
    private func markStaccatos(to mapView: GMSMapView) {
        let staccatosToAdd = viewModel.staccatosToAdd

        guard !staccatosToAdd.isEmpty else { return }

        for staccato in staccatosToAdd {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: staccato.latitude,
                longitude: staccato.longitude
            )
            marker.userData = staccato
            marker.map = mapView

            if marker.map == nil {
                print("⚠️ Marker(staccatoID: \(staccato.staccatoId)) was not added to the map!")
            } else {
                viewModel.displayedStaccatos.insert(staccato)
                viewModel.displayedMarkers[staccato.id] = marker
            }
        }
#if DEBUG
        print("✅ All staccato markers are added successfully!")
#endif
    }

    /// 스타카토 마커를 제거합니다.
    private func removeMarkers(from mapView: GMSMapView) {
        let staccatosToRemove = viewModel.staccatosToRemove

        guard !staccatosToRemove.isEmpty else { return }

        for staccato in staccatosToRemove {
            viewModel.displayedMarkers[staccato.id]?.map = nil
            viewModel.displayedMarkers.removeValue(forKey: staccato.id)
        }
    }

}
