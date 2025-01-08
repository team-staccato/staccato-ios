//
//  Staccato_iOSApp.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/2/25.
//

import GoogleMaps

import SwiftUI

@main
struct Staccato_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Maps SDK 초기화를 위해 AppDelegate 구현
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
        GMSServices.provideAPIKey(apiKey)
        
        return true
    }
}
