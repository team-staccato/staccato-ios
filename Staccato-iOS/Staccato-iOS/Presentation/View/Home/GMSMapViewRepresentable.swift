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
    @Environment(HomeModalManager.self) var homeModalManager

    private let mapView = GMSMapView()

    func makeUIView(context: Context) -> GMSMapView {
        STLocationManager.shared.delegate = context.coordinator

        mapView.settings.myLocationButton = false // 우측아래 내위치 버튼 숨김
        mapView.isMyLocationEnabled = true // 내위치 파란점으로 표시
        mapView.delegate = context.coordinator
        
        // 위치접근권한 없을 경우 초기 위치를 서울시청으로 함
        if !STLocationManager.shared.hasLocationAuthorization() {
            let seoulCityhall = CLLocationCoordinate2D(latitude: 37.5665851, longitude: 126.97820379999999)
            let camera = GMSCameraPosition.camera(withTarget: seoulCityhall, zoom: 15)
            
            moveCamera(on: mapView, to: camera)
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMarkers(to: uiView)

        // 특정 좌표가 있으면 카메라 이동
        if let cameraPosition = viewModel.cameraPosition {
            moveCamera(on: uiView, to: cameraPosition)

            Task {
                viewModel.cameraPosition = nil
            }
        }

        // 모달 크기가 조정된 만큼 지도를 scroll
        let currentSize = homeModalManager.modalSize
        let previousSize = homeModalManager.previousModalSize
        if currentSize != previousSize {
            scrollMap(on: uiView, currentSize: currentSize, previousSize: previousSize)
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
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        parent.moveCamera(on: parent.mapView, to: camera)
    }

    // 위치 접근 권한 바뀔 때 파란 점 표시 여부 업데이트 및 현위치로 이동
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            parent.mapView.isMyLocationEnabled = true

            if let coordinate = manager.location?.coordinate {
                let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
                parent.moveCamera(on: parent.mapView, to: camera)
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

    func updateMarkers(to mapView: GMSMapView) {
        markStaccatos(to: mapView)
        removeMarkers(from: mapView)
    }

    /// 지도에 스타카토 마커를 추가합니다.
    func markStaccatos(to mapView: GMSMapView) {
        let staccatosToAdd = viewModel.staccatosToAdd

        guard !staccatosToAdd.isEmpty else { return }

        for staccato in staccatosToAdd {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: staccato.latitude,
                longitude: staccato.longitude
            )
            marker.userData = staccato
            marker.icon = CategoryColorType.fromServerKey(staccato.staccatoColor)?.markerImage
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
    func removeMarkers(from mapView: GMSMapView) {
        let staccatosToRemove = viewModel.staccatosToRemove

        guard !staccatosToRemove.isEmpty else { return }

        for staccato in staccatosToRemove {
            viewModel.displayedMarkers[staccato.id]?.map = nil
            viewModel.displayedMarkers.removeValue(forKey: staccato.id)
        }
    }

    /// 카메라 좌표를 이동하며, 모달이 올라온 만큼 지도를 화면 중앙으로 scroll합니다.
    func moveCamera(on mapView: GMSMapView, to cameraPosition: GMSCameraPosition) {
        let deltaY =  (homeModalManager.modalSize.height - ScreenUtils.safeAreaInsets.top) / 2
        Task {
            mapView.camera = cameraPosition
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
        }
    }

    /// 모달 크기가 조정된 만큼 지도를 scroll합니다.
    func scrollMap(
        on mapView: GMSMapView,
        currentSize: HomeModalManager.ModalSize,
        previousSize: HomeModalManager.ModalSize
    ) {
        let deltaY = (currentSize.height - previousSize.height) / 2
        Task {
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
            homeModalManager.previousModalSize = currentSize
        }
    }

}
