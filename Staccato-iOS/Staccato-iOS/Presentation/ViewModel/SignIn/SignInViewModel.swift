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
        guard let loginResponse = try await NetworkService.shared.request(
                endpoint: AuthorizationAPI.login(nickname: nickName),
                responseType: LoginResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        AuthTokenManager.shared.saveToken(loginResponse.token)
        self.isLoggedIn = true
        
        return loginResponse
    }
    
    // 한글, 영어, 마침표, 언더바(_)만 허용
    func validateText(nickName: String) {
        let regex = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z._]{1,\(20)}$"
        isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickName)
    }
}
