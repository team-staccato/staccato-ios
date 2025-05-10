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

@MainActor
extension SignInViewModel {

    func checkAutoLogin() {
        if let token = AuthTokenManager.shared.getToken(),
           !token.isEmpty {
            isLoggedIn = true
        }
    }

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

    //한글, 영어, 숫자, 띄어쓰기 마침표(.), 밑줄(_) 허용
    func validateText(nickName: String) {
        let regex = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9._ ]{1,10}$"
        isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickName)
    }

}
