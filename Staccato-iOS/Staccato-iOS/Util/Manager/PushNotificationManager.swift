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
    @Published var moveToCategory: Int64 = 0
    @Published var moveToStaccato: Int64 = 0
    
    var type: PushNotificationType?
    
    private init() {}
    
    func handlePushNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let type = userInfo["type"] as? String else { return }
        
        self.type = PushNotificationType(rawValue: type)
        excuteTransition(userInfo)
    }
    
    private func excuteTransition(_ userInfo: [String: Any]) {
        Task {
            try await Task.sleep(for: .seconds(1))
            switch type {
            case .receiveInvitation:
                await MainActor.run {
                    shouldShowInvitation = true
                }
            case .acceptInvitation:
                if let categoryId = Int64(userInfo["categoryId"] as? String ?? "") {
                    await MainActor.run {
                        moveToCategory = categoryId
                    }
                }
            case .createStaccato, .createComment:
                if let staccatoId = Int64(userInfo["staccatoId"] as? String ?? "") {
                    await MainActor.run {
                        moveToStaccato = staccatoId
                    }
                }
            case .none:
                break
            }
        }
    }
}
