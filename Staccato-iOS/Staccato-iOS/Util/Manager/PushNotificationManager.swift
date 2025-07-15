//
//  PushNotificationManager.swift
//  Staccato-iOS
//
//  Created by 김영현 on 7/6/25.
//

import Foundation

final class PushNotificationManager: ObservableObject {
    static let shared = PushNotificationManager()
    
    @Published var shouldShowInvitation: Bool = false
    
    private init() {}
    
    func handlePushNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        if let type = userInfo["type"] as? String {
            switch type {
            case "RECEIVE_INVITATION":
                // 딜레이를 두고 실행하여 UI가 안정화된 후 처리
                Task {
                    try await Task.sleep(for: .seconds(1))
                    await MainActor.run {
                        shouldShowInvitation = true
                    }
                }
            case "ACCEPT_INVITATION":
                if let categoryId = userInfo["categoryId"] as? String {
                    // 나중에 구현
                    break
                }
            case "STACCATO_CREATED", "COMMENT_CREATED":
                if let staccatoId = userInfo["staccatoId"] as? String {
                    // 나중에 구현
                    break
                }
            default:
                break
            }
            
        }
    }
}
