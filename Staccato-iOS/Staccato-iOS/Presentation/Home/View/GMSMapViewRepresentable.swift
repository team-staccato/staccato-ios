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
    @EnvironmentObject var detentManager: BottomSheetDetentManager
    @Environment(NavigationManager.self) var navigationManager

    private let mapView = GMSMapView()

    func makeUIView(context: Context) -> GMSMapView {
        STLocationManager.shared.delegate = context.coordinator

        mapView.settings.myLocationButton = false // 우측아래 내위치 버튼 숨김
        mapView.isMyLocationEnabled = true // 내위치 파란점으로 표시
        mapView.delegate = context.coordinator
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        context.coordinator.clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        context.coordinator.clusterManager?.setMapDelegate(context.coordinator)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems(on: context)

        // 위치접근권한 없을 경우 초기 위치를 서울시청으로 함
        if !STLocationManager.shared.hasLocationAuthorization() {
            let seoulCityhall = CLLocationCoordinate2D(latitude: 37.5665851, longitude: 126.97820379999999)
            let camera = GMSCameraPosition.camera(withTarget: seoulCityhall, zoom: 15)
            
            moveCamera(on: mapView, to: camera)
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        updateMarkers(to: uiView, context: context)

        // 특정 좌표가 있으면 카메라 이동
        if let cameraPosition = viewModel.cameraPosition {
            moveCamera(on: uiView, to: cameraPosition)

            Task {
                viewModel.cameraPosition = nil
            }
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
        return Coordinator(self)
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


// MARK: - GMSMapView Delegate

extension GMSMapViewRepresentable.Coordinator: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Cluster 탭한 경우
        if let cluster = marker.userData as? GMUCluster {
            mapView.animate(toLocation: marker.position)
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            
            // TODO: 스타카토 리스트 팝업 띄우기
            print("🗺️did tap cluster: \(cluster)")
            return true
        }
        // Marker 탭한 경우
        else if let userdata = marker.userData as? StaccatoCoordinateModel {
            parent.navigationManager.navigate(to: .staccatoDetail(userdata.staccatoId))
            Task.detached { @MainActor in
                self.parent.detentManager.selectedDetent = BottomSheetDetent.medium.detent
            }
            return true
        }
        NSLog("⚠️🗺️ No any Cluster or StaccatoData found for this marker.")
        return false
    }

}


// MARK: - Private Methods

private extension GMSMapViewRepresentable {

    func updateMarkers(to mapView: GMSMapView, context: Context) {
        if markStaccatos(to: mapView) && removeMarkers(from: mapView) {
            // Call cluster() after items have been added to perform the clustering and rendering on map.
            print("🗺️updateMarkers")
            context.coordinator.clusterManager?.cluster()
        }
    }

    /// 지도에 스타카토 마커를 추가합니다.
    func markStaccatos(to mapView: GMSMapView) -> Bool {
        let staccatosToAdd = viewModel.staccatosToAdd

        guard !staccatosToAdd.isEmpty else { return false }

        for staccato in staccatosToAdd {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: staccato.latitude,
                longitude: staccato.longitude
            )
            marker.userData = staccato
            marker.icon = staccato.staccatoColor.markerImage
            marker.map = mapView

            if marker.map == nil {
                print("⚠️ Marker(staccatoID: \(staccato.staccatoId)) was not added to the map!")
            } else {
                viewModel.displayedStaccatos.insert(staccato)
                viewModel.displayedMarkers[staccato.id] = marker
            }
        }
        return true
    }

    /// 스타카토 마커를 제거합니다.
    func removeMarkers(from mapView: GMSMapView) -> Bool {
        let staccatosToRemove = viewModel.staccatosToRemove

        guard !staccatosToRemove.isEmpty else { return false }

        for staccato in staccatosToRemove {
            viewModel.displayedMarkers[staccato.id]?.map = nil
            viewModel.displayedMarkers.removeValue(forKey: staccato.id)
        }

        return true
    }

    /// 카메라 좌표를 이동하며, 모달이 올라온 만큼 지도를 화면 중앙으로 scroll합니다.
    func moveCamera(on mapView: GMSMapView, to cameraPosition: GMSCameraPosition) {
        let deltaY =  (detentManager.currentDetent.height - ScreenUtils.safeAreaInsets.top) / 2
        Task {
            mapView.camera = cameraPosition
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
        }
    }

    /// 모달 크기가 조정된 만큼 지도를 scroll합니다.
    func scrollMap(
        on mapView: GMSMapView,
        currentSize: BottomSheetDetent,
        previousSize: BottomSheetDetent
    ) {
        let deltaY = (currentSize.height - previousSize.height) / 2
        Task {
            mapView.animate(with: GMSCameraUpdate.scrollBy(x: 0, y: deltaY))
            detentManager.previousDetent = currentSize
        }
    }

    // TODO: 삭제
    /// Randomly generates cluster items within some extent of the camera and adds them to the cluster manager.
    private func generateClusterItems(on context: Context) {
        let kClusterItemCount = 5000
        let kCameraLatitude = 36.8
        let kCameraLongitude = 127.2
        let extent = 0.9
        for _ in 1...kClusterItemCount {
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let marker = GMSMarker(position: position)
            context.coordinator.clusterManager?.add(marker)
        }
    }

    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
      return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }

}
