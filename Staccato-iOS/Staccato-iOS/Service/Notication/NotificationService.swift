//
//  NotificationService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 6/7/25.
//

import Foundation

protocol NotificationServiceProtocol {

    func getHasNotification() async throws -> GetHasNotificationResponse
    
}

class NotificationService: NotificationServiceProtocol {
    func getHasNotification() async throws -> GetHasNotificationResponse {
        guard let hasNotification = try await NetworkService.shared.request(
            endpoint: NotificationEndPoint.getHasNotification,
            responseType: GetHasNotificationResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return hasNotification
    }
}
