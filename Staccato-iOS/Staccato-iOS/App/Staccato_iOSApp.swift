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
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
    
}
