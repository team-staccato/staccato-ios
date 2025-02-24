//
//  Staccato_iOSApp.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/2/25.
//

import SwiftUI

import GoogleMaps

@main
struct Staccato_iOSApp: App {
    
    init() {
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
        GMSServices.provideAPIKey(apiKey)
        LocationAuthorizationManager.shared.checkLocationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
    
}
