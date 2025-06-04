//
//  STNotificationManager.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 6/8/25.
//

import Foundation
import SwiftUI

@MainActor
final class STNotificationManager {
    
    static let shared = STNotificationManager()
    
    private init() {
        
    }
}

extension STNotificationManager {
    func getHasNotification(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let response = try await STService.shared.notificationService.getHasNotification()
                completion(response.isExist)
            } catch {
                print("Error: \(error)")
                completion(false)
            }
        }
    }
}
