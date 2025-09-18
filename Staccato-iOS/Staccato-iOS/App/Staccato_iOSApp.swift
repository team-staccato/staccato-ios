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

    private let navigationManager = NavigationManager()
    @StateObject private var bottomSheetDetentManager = BottomSheetDetentManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var mypageViewModel = MyPageViewModel()
    @StateObject private var signInViewModel: SignInViewModel
    
    @State private var isFirstLaunch: Bool = {
        let firstLaunchKey = "hasLaunchedBefore"
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: firstLaunchKey)
        
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: firstLaunchKey)
            return true
        } else {
            return false
        }
    }()

    init() {
        let signInViewModel = SignInViewModel()
        _signInViewModel = StateObject(wrappedValue: signInViewModel)

        signInViewModel.checkAutoLogin()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if signInViewModel.isLoggedIn {
                    HomeView()
                        .environmentObject(homeViewModel)
                        .environmentObject(mypageViewModel)
                        .environmentObject(bottomSheetDetentManager)
                        .onAppear {
                            if isFirstLaunch {
                                requestNotificationPermission()
                            } else {
                                checkNotificationPermission()
                            }
                        }
                } else {
                    SignInView()
                }
            }
            .environment(navigationManager)
            .environmentObject(signInViewModel)
            .preferredColorScheme(.light)
        }
    }
    
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error {
                print("알림 권한 요청 에러: \(error)")
                return
            }
            
            Task { @MainActor in
                if granted { UIApplication.shared.registerForRemoteNotifications() }
            }
        }
    }
    
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                Task { @MainActor in
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied, .ephemeral, .notDetermined, .provisional:
                print("사용자 거부 알림 권한 또는 아직 결정하지 않음")
            @unknown default:
                print("Unknown Status")
            }
        }
    }
}
