//
//  AuthTokenManager.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation

final class AuthTokenManager {
    static let shared = AuthTokenManager()
    private init() {}

    private let tokenKey = "authToken"

    // 🔹 토큰 저장
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    // 🔹 저장된 토큰 가져오기
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    // 🔹 토큰 삭제
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
