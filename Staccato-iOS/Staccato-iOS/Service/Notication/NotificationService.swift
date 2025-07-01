//
//  NotificationService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 6/7/25.
//

import Foundation

struct NotificationService {
    static func postNotificationToken(_ token: String, _ deviceId: String) async throws {
        try await NetworkService.shared.request(
            endpoint: NotificationEndPoint.postNotificationToken(token, deviceId)
        )
    }
    
    static func getHasNotification() async throws -> GetHasNotificationResponse {
        guard let hasNotification = try await NetworkService.shared.request(
            endpoint: NotificationEndPoint.getHasNotification,
            responseType: GetHasNotificationResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return hasNotification
    }
}
