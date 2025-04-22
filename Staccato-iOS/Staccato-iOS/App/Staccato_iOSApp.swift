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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let alertManager = StaccatoAlertManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(alertManager)
        }
    }
    
}
