//
//  LocationManager.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/24/25.
//

import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    // - TODO: 현재 위치 좌표를 이용하여 주소 데이터로 변경하기
    func requestLocation() {
        manager.requestLocation()
        print("now : \(currentCoordinate)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoordinate = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: \(error.localizedDescription)")
    }

}
