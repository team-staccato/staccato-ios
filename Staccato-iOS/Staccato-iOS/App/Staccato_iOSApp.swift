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

    private let navigationState = NavigationState()
    private let alertManager = StaccatoAlertManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var mypageViewModel = MyPageViewModel()
    @StateObject private var signInViewModel: SignInViewModel

    init() {
        let signInVM = SignInViewModel()
        _signInViewModel = StateObject(wrappedValue: signInVM)

        signInVM.checkAutoLogin()
    }
    
    var body: some Scene {
        WindowGroup {

            Group {
                if signInViewModel.isLoggedIn {
                    HomeView()
                        .environmentObject(homeViewModel)
                        .environmentObject(mypageViewModel)
                } else {
                    SignInView()
                }
            }
            .environment(navigationState)
            .environment(alertManager)
            .environmentObject(signInViewModel)
        }

    }

}
