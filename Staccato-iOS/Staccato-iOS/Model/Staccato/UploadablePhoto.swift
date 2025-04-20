//
//  UploadablePhoto.swift
//  Staccato-iOS
//
//  Created by 정승균 on 4/20/25.
//

import SwiftUI

@MainActor
@Observable
class UploadablePhoto: Identifiable, Equatable {
    let id: UUID = UUID()
    let photo: UIImage

    var isUploading = false
    var isFailed = false
    var imageURL: String?

    init(photo: UIImage) {
        self.photo = photo
    }

    nonisolated static func == (lhs: UploadablePhoto, rhs: UploadablePhoto) -> Bool {
        return lhs.id == rhs.id
    }

    func uploadImage() async throws {
        isUploading = true

        defer {
            isUploading = false
        }

        do {
            let imageURL = try await NetworkService.shared.uploadImage(self.photo)
            self.imageURL = imageURL.imageUrl
        } catch {
            isFailed = true
            throw error
        }
    }
}
