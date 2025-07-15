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

// Maps SDK 초기화 및 FCM을 위해 AppDelegate 구현
final class AppDelegate: NSObject, UIApplicationDelegate {
    
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
        
        NotificationCenter.default.addObserver(
            forName: .pushNotificationReceived,
            object: nil,
            queue: .main
        ) { notification in
            PushNotificationManager.shared.handlePushNotification(notification)
        }
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error {
                print("FCM 토큰 가져오기 실패: \(error)")
            } else if let token {
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                Task { try await NotificationService.postNotificationToken(token, deviceID) }
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        let userInfo = response.notification.request.content.userInfo
        
        NotificationCenter.default.post(
            name: .pushNotificationReceived,
            object: nil,
            userInfo: userInfo as? [String: Any] ?? [:]
        )
        
        completionHandler()
    }
}
