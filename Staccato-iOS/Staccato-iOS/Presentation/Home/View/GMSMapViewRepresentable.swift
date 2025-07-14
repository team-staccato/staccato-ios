//
//  MapViewControllerBridge.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps
import GoogleMapsUtils

import SwiftUI

struct GMSMapViewRepresentable: UIViewRepresentable {

    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(NavigationManager.self) var navigationManager

    @StateObject private var detentManager = BottomSheetDetentManager.shared
    private let mapView = GMSMapView()

    func makeUIView(context: Context) -> GMSMapView {
        STLocationManager.shared.delegate = context.coordinator

        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator

        let iconGenerator = StaccatoClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)

        renderer.delegate = context.coordinator

        context.coordinator.clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        context.coordinator.clusterManager?.setMapDelegate(context.coordinator)

        // 위치접근권한 없을 경우 초기 위치를 서울시청으로 함
        if !STLocationManager.shared.hasLocationAuthorization() {
            let seoulCityhall = CLLocationCoordinate2D(latitude: 37.5665851, longitude: 126.97820379999999)
            let camera = GMSCameraPosition.camera(withTarget: seoulCityhall, zoom: 15)
            moveCamera(on: mapView, to: camera)
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMarkers(context: context)

        // 특정 좌표가 있으면 카메라 이동
        if let cameraPosition = viewModel.cameraPosition {
            moveCamera(on: uiView, to: cameraPosition)
            Task { viewModel.cameraPosition = nil }
        }

        // 모달 크기가 조정된 만큼 지도를 scroll
        let currentSize = detentManager.currentDetent
        let previousSize = detentManager.previousDetent
        if currentSize != previousSize {
            scrollMap(on: uiView, currentSize: currentSize, previousSize: previousSize)
        }
#if DEBUG
        print("🗺️GMSMapViewRepresentable updated")
#endif
    }

}


// MARK: - Coordinator

extension GMSMapViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject {
        let parent: GMSMapViewRepresentable
        var clusterManager: GMUClusterManager?

        init(_ parent: GMSMapViewRepresentable) {
            self.parent = parent
        }
    }

}


// MARK: - LocationManager Delegate

extension GMSMapViewRepresentable.Coordinator: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {
            print("❌🗺️ GMSMapView Location Optional Binding Failed")
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


// MARK: - GMUClusterRenderer Delegate

extension GMSMapViewRepresentable.Coordinator: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let item = marker.userData as? GMUClusterItemWrapper {
            marker.userData = item
            marker.icon = item.staccato.staccatoColor.markerImage
            marker.title = item.staccato.title
        }
    }
}


// MARK: - GMSMapView Delegate

extension GMSMapViewRepresentable.Coordinator: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Cluster tapped
        if let cluster = marker.userData as? GMUCluster {
            parent.viewModel.staccatoClusterList = cluster.items.compactMap { ($0 as? GMUClusterItemWrapper)?.staccato } // TODO: 수정
            parent.viewModel.isStaccatoListPresented = true
            return true
        }
        // Marker tapped
        else if let marker = marker.userData as? GMUClusterItemWrapper {
            parent.navigationManager.navigate(to: .staccatoDetail(marker.staccato.staccatoId))
            Task.detached { @MainActor in
                self.parent.detentManager.selectedDetent = BottomSheetDetent.medium.detent
            }
            return true
        }
        return false
    }
}


// MARK: - Helper

private extension GMSMapViewRepresentable {

    func updateMarkers(context: Context) {
        if markStaccatos(context: context) || removeMarkers(context: context) {
            context.coordinator.clusterManager?.cluster()
        }
    }

    func markStaccatos(context: Context) -> Bool {
        let staccatosToAdd = viewModel.staccatosToAdd
        guard !staccatosToAdd.isEmpty else { return false }

        for staccato in staccatosToAdd {
            let item = GMUClusterItemWrapper(staccato)
            context.coordinator.clusterManager?.add(item)
            viewModel.displayedStaccatos.insert(staccato)
        }
        return true
    }

    func removeMarkers(context: Context) -> Bool {
        let staccatosToRemove = viewModel.staccatosToRemove
        guard !staccatosToRemove.isEmpty else { return false }

        for staccato in staccatosToRemove {
            viewModel.displayedStaccatos.remove(staccato)
        }
        context.coordinator.clusterManager?.clearItems()
        context.coordinator.clusterManager?.add(viewModel.displayedStaccatos.map { GMUClusterItemWrapper($0) })
        return true
    }

    func moveCamera(on mapView: GMSMapView, to cameraPosition: GMSCameraPosition) {
        let deltaY = (detentManager.currentDetent.height - ScreenUtils.safeAreaInsets.top) / 2
        Task {
            mapView.camera = cameraPosition
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
        }
    }

    func scrollMap(on mapView: GMSMapView, currentSize: BottomSheetDetent, previousSize: BottomSheetDetent) {
        let deltaY = (currentSize.height - previousSize.height) / 2
        Task {
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
            detentManager.previousDetent = currentSize
        }
    }

}
