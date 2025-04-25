//
//  LocationManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/17/25.
//

import CoreLocation
import SwiftUI
import Observation

@Observable
class STLocationManager: NSObject {

    static let shared = STLocationManager()

    private let locationManager = CLLocationManager()
    
    var delegate: CLLocationManagerDelegate? {
        get { locationManager.delegate }
        set { locationManager.delegate = newValue }
    }

    var hasLocationAuthorization: Bool = false

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        updateAuthorizationStatus()
    }

}


// MARK: - CLLocationManager Delegate

extension STLocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 상태 변경 시 처리
        checkLocationAuthorization()
        updateAuthorizationStatus()
    }

}


// MARK: - Authorization Methods

extension STLocationManager {

    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            // 처음 실행 시 권한 요청
            print("🗺️Location authorization: NotDetermined")
            locationManager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            // 권한 거부 상태: 설정 앱으로 유도
            print("🗺️Location authorization: Restricted or Denied")
            showAlertToOpenSettings()

        case .authorizedWhenInUse, .authorizedAlways:
            // "앱 사용 중 허용" 상태: 앱 플로우 진입
            print("🗺️Location authorization: AuthorizedWhenInUse or AuthorizedAlways")

        @unknown default:
            break
        }
    }

    private func updateAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        hasLocationAuthorization = (status == .authorizedAlways || status == .authorizedWhenInUse)
    }

    private func showAlertToOpenSettings() {
        // 설정 앱으로 유도하는 Alert
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(
                title: "위치 권한 필요",
                message: "Staccato 사용을 위해 설정에서 위치접근 권한을 허용해주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "설정 열기", style: .default) { _ in
                UIApplication.shared.open(settingsURL)
            })

            // TODO: 리팩토링 ('windows' was deprecated in iOS 15.0)
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
    }

}


// MARK: - Location Methods

extension STLocationManager {

    /// 현재 위치를 업데이트합니다.
    func updateLocationForOneSec() {
        locationManager.startUpdatingLocation()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.locationManager.stopUpdatingLocation() // 무한 호출 방지를 위해 0.1초 뒤 업데이트 멈춤
        }
    }

    /// 현재 좌표의 장소 정보를 반환합니다 (역지오코딩)
    func getCurrentPlaceInfo(completion: @escaping (StaccatoPlaceModel) -> Void) {
        updateLocationForOneSec()

        guard let coordinate = locationManager.location?.coordinate else {
            print("❌ 옵셔널 바인딩 해제 실패 - getCurrentAddressAndCoordinate")
            return
        }

        let geocoder = CLGeocoder()
        let location = CLLocation(coordinate.latitude, coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("📍ReverseGeocode Fail: \(String(describing: error?.localizedDescription))")
                return
            }
            let address = self.localizedFormattedAddress(from: placemark)
            completion(
                StaccatoPlaceModel(
                    name: placemark.name ?? address,
                    address: address,
                    coordinate: location.coordinate
                )
            )
        }
    }

}


// MARK: - Helper

extension STLocationManager {

    /// 동양 또는 서양 스타일로 주소를 포매팅합니다.
    ///
    /// ## 국가별 주소 포맷
    /// 한국, 중국, 일본
    /// ```
    /// [우편번호] 국가명 도시명 도로명 빌딩번호
    /// ```
    /// 이외 국가:
    /// ```
    /// Building number, Street, City, State/province, PostalCode, Country
    /// ```
    func localizedFormattedAddress(from placemark: CLPlacemark) -> String {
        let countryCode = placemark.isoCountryCode ?? ""
        var parts: [String] = []

        // Common fields
        let subThoroughfare = placemark.subThoroughfare ?? ""
        let thoroughfare = placemark.thoroughfare ?? ""
        let locality = placemark.locality ?? ""
        let postalCode = placemark.postalCode ?? ""
        let country = placemark.country ?? ""

        if countryCode == "KR" || countryCode == "CN" || countryCode == "JP" {
            // Eastern-style spaced address
            if !postalCode.isEmpty { parts.append("[\(postalCode)]") }
            if !country.isEmpty { parts.append(country) }
            if !thoroughfare.isEmpty || !subThoroughfare.isEmpty {
                parts.append("\(thoroughfare) \(subThoroughfare)".trimmingCharacters(in: .whitespaces))
            }

            return parts.joined(separator: " ")

        } else {
            // Western-style comma-separated address
            if !subThoroughfare.isEmpty || !thoroughfare.isEmpty {
                parts.append("\(subThoroughfare) \(thoroughfare)".trimmingCharacters(in: .whitespaces))
            }
            if !locality.isEmpty {
                parts.append(locality)
            }
            if let adminArea = placemark.administrativeArea {
                parts.append(adminArea)
            }
            if !postalCode.isEmpty {
                parts.append(postalCode)
            }
            if !country.isEmpty {
                parts.append(country)
            }

            return parts.joined(separator: ", ")
        }
    }

}
