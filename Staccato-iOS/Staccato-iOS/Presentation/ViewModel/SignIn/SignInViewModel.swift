//
//  SignInViewModel.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var nickName: String = "" {
        didSet {
            if nickName.count > 20 {
                nickName = String(nickName.prefix(20))
            }
        }
    }
    @Published var isLoggedIn: Bool = false

    var isButtonDisabled: Bool {
        nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension SignInViewModel {
    func login() {
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
