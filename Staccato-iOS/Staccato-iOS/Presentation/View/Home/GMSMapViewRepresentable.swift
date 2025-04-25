//
//  MapViewControllerBridge.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct GMSMapViewRepresentable: UIViewRepresentable {
    
    @ObservedObject var viewModel: HomeViewModel
    @Environment(NavigationState.self) var navigationState
    
    private let mapView = GMSMapView()
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        // locationManager delegate
        viewModel.locationManager.delegate = context.coordinator
        
        // mapView 설정
        mapView.settings.myLocationButton = false // 우측아래 내위치 버튼 숨김
        mapView.isMyLocationEnabled = true // 내위치 파란점으로 표시
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        markStaccatos(to: uiView)
#if DEBUG
        print("GMSMapViewRepresentable updated")
#endif
    }
    
}


// MARK: - Coordinator

extension GMSMapViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, navigationState)
    }
    
    final class Coordinator: NSObject {
        let parent: GMSMapViewRepresentable
        let navigationState: NavigationState
        
        init(_ parent: GMSMapViewRepresentable, _ navigationState: NavigationState) {
            self.parent = parent
            self.navigationState = parent.navigationState
        }
    }
    
}

extension GMSMapViewRepresentable.Coordinator: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {
            print("❌ \(String(describing: StaccatoError.optionalBindingFailed.errorDescription)) - GMSMapView location")
            return
        }
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 13)
        parent.mapView.animate(to: camera)
    }

    // NOTE: 위치 접근권한이 없을 때 초기 위치를 서울시청으로 함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if parent.viewModel.isInitialCameraMove {
            let seoulCityhall = CLLocationCoordinate2D(37.5664056, 126.9778222)
            let camera = GMSCameraPosition.camera(withTarget: seoulCityhall, zoom: 13)
            parent.mapView.animate(to: camera)
            parent.viewModel.isInitialCameraMove = false
        } else {
            LocationAuthorizationManager.shared.checkLocationAuthorization()
        }
    }
    
    // 위치 접근 권한 바뀔 때 파란 점 표시 여부 업데이트
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            parent.mapView.isMyLocationEnabled = true
        } else {
            parent.mapView.isMyLocationEnabled = false
        }
    }

}


extension GMSMapViewRepresentable.Coordinator: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let userdata = marker.userData as? StaccatoCoordinateModel {
            navigationState.navigate(to: .staccatoDetail(userdata.staccatoId))
        } else {
            print("⚠️ No StaccatoData found for this marker.")
        }
        return false
    }
    
}


// MARK: - Private Methods

private extension GMSMapViewRepresentable {

    /// 지도에 스타카토 마커를 추가합니다.
    private func markStaccatos(to mapView: GMSMapView) {
        let notMarkedStaccatos = viewModel.notMarkedStaccatos

        guard !notMarkedStaccatos.isEmpty else { return }

        for staccato in notMarkedStaccatos {
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
                viewModel.markedStaccatos.append(staccato)
            }
        }
#if DEBUG
        print("✅ All staccato markers are added successfully!")
#endif
    }

}
