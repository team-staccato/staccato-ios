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
        STLocationManager.shared.delegate = context.coordinator

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
        let location: CLLocation = locations.last!
        print("📍Location: \(location)")

        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 5)
        
        parent.mapView.animate(to: camera)
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
