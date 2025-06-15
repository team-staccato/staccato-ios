//
//  AppDelegate.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/10/25.
//

import GoogleMaps
import GooglePlacesSwift
import FirebaseCore
import FirebaseMessaging
import UIKit

// Maps SDK 초기화를 위해 AppDelegate 구현
final class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Google Map
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
        GMSServices.provideAPIKey(apiKey)
        let _ = PlacesClient.provideAPIKey(apiKey)
        
        // FCM
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // 알림 센터 델리게이트 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 권한 요청 및 APNs 등록
        requestNotificationPermission()
        
        return true
    }
    
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error {
                print("알림 권한 요청 에러: \(error)")
                return
            }
            
            Task { @MainActor in
                if granted {
                    print("✅ 권한 허용됨 - APNs 등록 시작")
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("❌ 권한 거부됨")
                }
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        registerFCMToken()
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs 토큰 등록 실패: \(error.localizedDescription)")
    }
    
    private func registerFCMToken() {
        Messaging.messaging().token { token, error in
            if let error {
                print("FCM 토큰 가져오기 실패: \(error)")
            } else if let token {
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                print("FCM 토큰: \(token)")
                Task { try await NotificationService.postNotificationToken(token, deviceID) }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print("FCM 토큰: \(String(describing: fcmToken)), deviceId: \(deviceID)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
