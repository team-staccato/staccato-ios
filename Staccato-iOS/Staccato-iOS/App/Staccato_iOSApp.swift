//
//  Staccato_iOSApp.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/2/25.
//

import SwiftUI

@main
struct Staccato_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
