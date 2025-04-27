//
//  UploadablePhoto.swift
//  Staccato-iOS
//
//  Created by 정승균 on 4/20/25.
//

import SwiftUI

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
            // TODO: Image Service로 변경
            let imageRequest = PostImageRequest(image: self.photo)
            let imageURL = try await STService.shared.imageService.uploadImage(imageRequest)
            self.imageURL = imageURL.imageUrl
        } catch {
            isFailed = true
            throw error
        }
    }
}
