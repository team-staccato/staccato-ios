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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 상태 변경 시 처리
        checkLocationAuthorization()
        updateAuthorizationStatus()
        let geocoder = CLGeocoder()
        guard let coordinate = manager.location?.coordinate else {
            print("❌", StaccatoError.optionalBindingFailed)
            return
        }
        // Swift의 ReverseGeocoding
        reverseGeocodeCoordinate(manager.location ?? CLLocation())
        
        // Google ReverseGeocoding
        reverseGeocodeCoordinate(coordinate) { address in
            if let address = address {
                print("🍎🍎🍎Address: \(address)")
            } else {
                print("🍎🍎🍎Failed to get address.")
            }
        }
        
        fetchPlaceInfo(at: coordinate) { name, address, coordinate in
            print("🌸🌸🌸", name, address, coordinate)
        }
    }

}



import GoogleMaps
import GooglePlaces

extension LocationAuthorizationManager {
    
    // Swift의 ReverseGeocoding
    func reverseGeocodeCoordinate(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("📍ReverseGeocode Fail: \(String(describing: error?.localizedDescription))")
                return
            }
            print("🍏🍏🍏placemark: \(placemark)")
            print("🍏🍏🍏name: \(placemark.name)")
            print("🍏🍏🍏throughfare: \(placemark.thoroughfare)")
        }
    }
    
    // Google ReverseGeocoding
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Google Maps reverse geocode failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let address = response?.firstResult() {
                var addressLines: [String] = []
                
                if let lines = address.lines {
                    addressLines.append(contentsOf: lines)
                }

                let fullAddress = addressLines.joined(separator: ", ")
                completion(fullAddress)
            } else {
                completion(nil)
            }
        }
    }
    
    // Google 근처 장소 정보 추출
    func fetchPlaceInfo(at coordinate: CLLocationCoordinate2D, completion: @escaping (String?, String?, CLLocationCoordinate2D?) -> Void) {
        let placesClient = GMSPlacesClient.shared()

        let locationBias = GMSPlaceRectangularLocationOption(
            CLLocationCoordinate2D(latitude: coordinate.latitude - 0.001, longitude: coordinate.longitude - 0.001),
            CLLocationCoordinate2D(latitude: coordinate.latitude + 0.001, longitude: coordinate.longitude + 0.001)
        )

        let fields: GMSPlaceField = [.name, .formattedAddress, .coordinate]

        let token = GMSAutocompleteSessionToken.init() // Optional

        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { likelihoods, error in
            if let error = error {
                print("Places fetch error: \(error.localizedDescription)")
                completion(nil, nil, nil)
                return
            }

            if let place = likelihoods?.first?.place {
                completion(place.name, place.formattedAddress, place.coordinate)
            } else {
                completion(nil, nil, nil)
            }
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
 
 
 */
