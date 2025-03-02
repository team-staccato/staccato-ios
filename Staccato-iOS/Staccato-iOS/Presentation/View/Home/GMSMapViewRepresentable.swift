//
//  MapViewControllerBridge.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI


struct GMSMapViewRepresentable: UIViewRepresentable {
    
    private let locationManager = CLLocationManager()
    private let mapView = GMSMapView(frame: .zero)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        // locationManager 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = context.coordinator
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            locationManager.stopUpdatingLocation() // 무한 호출 방지를 위해 1초 뒤 업데이트 멈춤
        }
        
        // mapView 설정
        mapView.settings.myLocationButton = true // 우측아래 내위치
        mapView.isMyLocationEnabled = true // 내위치 파란점으로 표시
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
    
}

extension GMSMapViewRepresentable {
    
    final class Coordinator: NSObject {
        let parent: GMSMapViewRepresentable
        
        init(_ parent: GMSMapViewRepresentable) {
            self.parent = parent
        }
    }
    
}

extension GMSMapViewRepresentable.Coordinator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        
        parent.mapView.animate(to: camera)
    }
    
}


// MARK: - Internal Methods

extension GMSMapViewRepresentable {
    
    func updateLocationForOneSec() {
        locationManager.startUpdatingLocation()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            locationManager.stopUpdatingLocation() // 무한 호출 방지를 위해 1초 뒤 업데이트 멈춤
        }
    }
    
}
