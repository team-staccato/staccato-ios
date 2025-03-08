//
//  SignInViewModel.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isValid: Bool = true
}

extension SignInViewModel {
    func login(nickName: String) async throws -> LoginResponse {
        return try await withCheckedThrowingContinuation { continuation in
            NetworkService.shared.request(
                endpoint: AuthorizationAPI.login(nickname: nickName),
                responseType: LoginResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    AuthTokenManager.shared.saveToken(response.token)
                    self.isLoggedIn = true
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 한글, 영어, 마침표, 언더바(_)만 허용
    func validateText(nickName: String) {
        let regex = "^[가-힣a-zA-Z._]{1,\(20)}$"
        isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickName)
    }
}
