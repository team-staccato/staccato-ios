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
        
        //원격 알림 시스템에 앱을 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().delegate = self
        Messaging.messaging().apnsToken = deviceToken
        getFCMToken()
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs 토큰 등록 실패: \(error.localizedDescription)")
    }
    
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error)")
            } else if let token = token {
                print("FCM 토큰: \(token)")
                // 서버에 토큰 전송 등의 작업 수행
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM 토큰: \(String(describing: fcmToken))")
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
