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
    private let userIdKey = "userId"

    // 🔹 토큰(+유저아이디) 저장
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        
        if let userId = parseUserID(from: token) {
            UserDefaults.standard.set(userId, forKey: userIdKey)
        }
    }

    // 🔹 저장된 토큰 가져오기
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

    // 🔹 저장된 유저 아이디 가져오기
    func getUserId() -> Int64? {
        return UserDefaults.standard.object(forKey: userIdKey) as? Int64
    }

    // 🔹 토큰(+유저아이디) 삭제
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }

}


// MARK: - Helper

private extension AuthTokenManager {

    func parseUserID(from token: String) -> Int64? {
        let parts = token.split(separator: ".")
        guard parts.count > 1 else { return nil } // payload가 없으면 nil 반환

        let payload = String(parts[1])

        // Base64 디코딩
        guard let data = Data(base64Encoded: payload.padding(toLength: ((payload.count+3)/4)*4,
                                                             withPad: "=",
                                                             startingAt: 0),
                              options: .ignoreUnknownCharacters) else {
            print("❌userId Base64 디코딩 실패")
            return nil
        }
        
        // JSON 디코딩
        if let json = try? JSONSerialization.jsonObject(with: data),
           let dict = json as? [String: Any],
           let userId = dict["id"] as? Int64 {
            return userId
        }

        print("❌ userId JSON 디코딩 실패")
        return nil
    }

}
