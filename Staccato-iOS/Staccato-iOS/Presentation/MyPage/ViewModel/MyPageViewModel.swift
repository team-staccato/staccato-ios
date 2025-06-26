//
//  MyPageViewModel.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Foundation
import UIKit

final class MyPageViewModel: ObservableObject {
    @Published var profile: ProfileModel?
}

extension MyPageViewModel {
    @MainActor
    func fetchProfile() {
        Task {
            do {
                let response = try await MemberService.getProfile()
                
                let profile: ProfileModel = ProfileModel(
                    nickname: response.nickname,
                    profileImageUrl: response.profileImageUrl,
                    code: response.code
                )
                
                self.profile = profile
            } catch {
                print("Error fetching staccatos: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func uploadProfileImage(_ image: UIImage) {
            Task {
                do {
                    let requestBody = PostImageRequest(image: image)
                    let _ = try await STService.shared.imageService.uploadProfileImage(requestBody)
                    
                    fetchProfile()
                } catch {
                    print(error)
                }
            }
        }
}
