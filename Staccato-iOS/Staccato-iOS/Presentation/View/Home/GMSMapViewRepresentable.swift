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
        if viewModel.presentedStaccatos.isEmpty { // NOTE: 마커 없는 경우만 실행
            addAllStaccatoMarkers(to: uiView)
        }
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
        let location: CLLocation = locations.last!
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
    
    private func addAllStaccatoMarkers(to mapView: GMSMapView) {
        let staccatos = viewModel.staccatoCoordinates
        guard !staccatos.isEmpty else { return }
        
        mapView.clear()
        
        for staccato in staccatos {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: staccato.latitude,
                longitude: staccato.longitude
            )
            marker.userData = staccato
            marker.map = mapView
            
#if DEBUG
            if marker.map == nil {
                print("⚠️ Marker(staccatoID: \(staccato.staccatoId)) was not added to the map!")
            } else {
                print("✅ Marker(staccatoID: \(staccato.staccatoId)) added successfully!")
                viewModel.presentedStaccatos.append(staccato)
            }
#endif
        }
    }
    
}
