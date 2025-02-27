//
//  AppDelegate.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/10/25.
//

import GoogleMaps
import GooglePlacesSwift

import UIKit

// Maps SDK 초기화를 위해 AppDelegate 구현
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
        GMSServices.provideAPIKey(apiKey)
        let _ = PlacesClient.provideAPIKey(apiKey)

        return true
    }
    
}
