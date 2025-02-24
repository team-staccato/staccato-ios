//
//  LocationManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/17/25.
//

import CoreLocation
import SwiftUI

class LocationAuthorizationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationAuthorizationManager()
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            // 처음 실행 시 권한 요청
            print("🗺️Location authorization: notDetermined")
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            // 권한 거부 상태: 설정 앱으로 유도
            print("🗺️Location authorization: restricted / denied")
            showAlertToOpenSettings()
            
        case .authorizedWhenInUse, .authorizedAlways:
            // "앱 사용 중 허용" 상태: 앱 플로우 진입
            print("🗺️Location authorization: authorizedWhenInUse / authorizedAlways")
            proceedToAppFlow()
            
        @unknown default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 상태 변경 시 처리
        checkLocationAuthorization()
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
    
    private func proceedToAppFlow() {
        GMSMapViewRepresentable.shared.updateLocationForOneSec()
     }
    
}
