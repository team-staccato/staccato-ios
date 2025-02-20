//
//  SignInViewModel.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @State var isLoggedIn: Bool = false
}

extension SignInViewModel {
    func login(nickName: String) {
        NetworkService.shared.request(
            endpoint: AuthorizationAPI.login(nickname: nickName),
            responseType: LoginResponse.self
        ) { result in
            switch result {
            case .success(let response):
                AuthTokenManager.shared.saveToken(response.token)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            case .failure(let error):
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
    }
}
