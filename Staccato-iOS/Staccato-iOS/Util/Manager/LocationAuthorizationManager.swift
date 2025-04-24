//
//  LocationManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/17/25.
//

import CoreLocation
import Contacts
import SwiftUI
import Observation

@Observable
class LocationAuthorizationManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = LocationAuthorizationManager()
    
    private var locationManager = CLLocationManager()
    
    var hasLocationAuthorization: Bool = false
    
    
    // MARK: - Methods
    
    override init() {
        super.init()
        locationManager.delegate = self
        updateAuthorizationStatus()
    }
    
    private func updateAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        hasLocationAuthorization = (status == .authorizedAlways || status == .authorizedWhenInUse)
    }
    
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


// MARK: - CLLocationManagerDelegate

extension LocationAuthorizationManager: CLLocationManagerDelegate {
    
    func updateLocationForOneSec() {
        locationManager.startUpdatingLocation()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.locationManager.stopUpdatingLocation() // 무한 호출 방지를 위해 0.1초 뒤 업데이트 멈춤
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 상태 변경 시 처리
        checkLocationAuthorization()
        updateAuthorizationStatus()
    }
    
    /// 입력한 좌표의 주소를 반환합니다(역지오코딩)
    func getPlaceInfo(_ location: CLLocation, completion: @escaping (StaccatoPlaceModel) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("📍ReverseGeocode Fail: \(String(describing: error?.localizedDescription))")
                return
            }
            print("🥑placemark: \(placemark) \n ◾️name: \(placemark.name), ◾️locality: \(placemark.locality), ◾️sublocality: \(placemark.subLocality), \n◾️administrative: \(placemark.administrativeArea), ◾️subAdministrative: \(placemark.subAdministrativeArea) ◾️country: \(placemark.country) \n◾️thoroughfare: \(placemark.thoroughfare), subThoroughfare: \(placemark.subThoroughfare)")
            
//            let formatter = CNPostalAddressFormatter()
//            if let postal = placemark.postalAddress {
//                let addressString = formatter.string(from: postal)
//                print("◾️ Formatted address from postal: [\(placemark.postalCode)] \(addressString) \n◾️raw: \(placemark.postalAddress)")
//            }
//            
//            let localized = self.localizedFormattedAddress(from: placemark)
            let address = self.localizedFormattedAddress(from: placemark)
            print("☄️ localized: \(address)")
            completion(
                StaccatoPlaceModel(
                    name: placemark.name ?? address,
                    address: address,
                    coordinate: location.coordinate
                )
            )
        }
    }
    
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

extension LocationAuthorizationManager {

    /// ## 주소 형식
    /// ### 한국, 중국, 일본
    /// => [우편번호] 국가명 도시명 도로명 빌딩번호
    /// ### 이외 국가:
    /// => building number, street, city, state/province, postalCode, country
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

/*
 결과
 
 🍏🍏placemark: 167 Ocean Blvd, 167 Ocean Blvd, 애틀랜틱 하이랜드, NJ  07716, 미 합중국 @ <+40.41210000,-74.02400000> +/- 100.00m, region CLCircularRegion (identifier:'<+40.41189630,-74.02446370> radius 70.67', center:<+40.41189630,-74.02446370>, radius:70.67m)
 🍏🍏name: Optional("167 Ocean Blvd")
 🍏🍏throughfare: Optional("Ocean Blvd")
 🍎🍎Address: 3 Hook Harbor Rd, Atlantic Highlands, NJ 07716 미국
 
 
 🍏🍏🍏placemark: 개운사1길 9999, 대한민국 서울특별시 성북구 개운사1길 9999, 02842 @ <위도,경도> +/- 100.00m, region CLCircularRegion (identifier:' <위도,경도> radius 70.65', center: <위도,경도>, radius:70.65m)
 🍏🍏🍏name: Optional("개운사1길 9999")
 🍏🍏🍏throughfare: Optional("개운사1길")
 🍎🍎🍎Address: 대한민국 서울특별시 성북구 개운사1길 9999
 🌸🌸🌸 Optional("안암역") Optional("대한민국 서울특별시") Optional(__C.CLLocationCoordinate2D(latitude: 37.586296, longitude: 127.029137))
 
 📍Location: <+37.78583400,-122.40641700>
 🍏🍏🍏placemark: Powell St, Powell St, 2–16 Ellis St, 샌프란시스코, CA  94108, 미 합중국 @ <+37.78583400,-122.40641700> +/- 100.00m, region CLCircularRegion (identifier:'<+37.78572321,-122.40636002> radius 70.65', center:<+37.78572321,-122.40636002>, radius:70.65m)
 🍏🍏🍏name: Optional("Powell St")
 🍏🍏🍏throughfare: Optional("Ellis St")
 🍎🍎🍎Address: 1800 Ellis St, San Francisco, CA 94115 미국
 🌸🌸🌸 Optional("Trader Joe\'s") Optional("10 4th St, San Francisco, CA 94103 미국") Optional(__C.CLLocationCoordinate2D(latitude: 37.78532309, longitude: -122.4055518))
 🚀 place: StaccatoPlaceModel(name: "파월 스트리트", address: "Powell St, San Francisco, CA, 미국", coordinate: __C.CLLocationCoordinate2D(latitude: 37.7965073, longitude: -122.4101021))
 🚀 place: StaccatoPlaceModel(name: "1800 Ellis St", address: "1800 Ellis St, San Francisco, CA 94115 미국", coordinate: __C.CLLocationCoordinate2D(latitude: 37.7820817, longitude: -122.4360476))
 ◾️name: Optional("Powell St"),
◾️locality: Optional("샌프란시스코"), ◾️sublocality: Optional("Union Square"),
//◾️administrative: Optional("CA"), ◾️subAdministrative: Optional("샌프란시스코") ◾️country: Optional("미 합중국")
◾️thoroughfare: Optional("Ellis St"), subThoroughfare: Optional("2–16")
 ◾️ Formatted address from postal: [Optional("94108")]
 2–16 Ellis St
 샌프란시스코 CA 94108
 미 합중국
 ◾️raw: Optional(<CNPostalAddress: 0x6000021e14f0: street=2–16 Ellis St, subLocality=Union Square, city=샌프란시스코, subAdministrativeArea=샌프란시스코, state=CA, postalCode=94108, country=미 합중국, countryCode=US>)
 ☄️ localized: 2–16 Ellis St, 샌프란시스코, CA, 94108, 미 합중국
 
 
 📍Location: <+37.47926185,+126.95199200>
 🥑placemark: 봉천동 864-1, 대한민국 서울특별시 관악구 봉천동 864-1, 08787 @ <+37.47926229,+126.95199219> +/- 100.00m, region CLCircularRegion (identifier:'<+37.47917800,+126.95206120> radius 70.65', center:<+37.47917800,+126.95206120>, radius:70.65m)
 ◾️name: Optional("봉천동 864-1"),
◾️locality: Optional("서울특별시"), ◾️sublocality: Optional("봉천동"),
◾️administrative: Optional("서울특별시"), ◾️subAdministrative: nil ◾️country: Optional("대한민국")
◾️thoroughfare: Optional("봉천동"), subThoroughfare: Optional("864-1")
 ◾️ Formatted address from postal: [Optional("08787")]
 대한민국
 서울특별시
 서울특별시
 봉천동 864-1
 08787
 ◾️raw: Optional(<CNPostalAddress: 0x302111860: street=봉천동 864-1, subLocality=봉천동, city=서울특별시, subAdministrativeArea=, state=서울특별시, postalCode=08787, country=대한민국, countryCode=KR>)
 ☄️ localized: [08787] 대한민국 서울특별시 봉천동 봉천동 864-1

 */
