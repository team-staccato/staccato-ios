//
//  RecoverAccountViewModel.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 4/20/25.
//

import SwiftUI

class RecoverAccountViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

extension RecoverAccountViewModel {
    func login(withCode code: String) async throws -> LoginResponse {
        guard let loginResponse = try await NetworkService.shared.request(
            endpoint: AuthorizationAPI.recoverAccount(withCode: code),
                responseType: LoginResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        AuthTokenManager.shared.saveToken(loginResponse.token)
        self.isLoggedIn = true
        
        return loginResponse
    }
}
