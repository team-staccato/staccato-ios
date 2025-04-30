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

    init(imageUrl: String) async {
        guard let url = URL(string: imageUrl) else {
            self.imageURL = imageUrl
            self.photo = UIImage()

            return
        }

        self.imageURL = imageUrl

        let loadedImage = await Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                return UIImage(data: data)
            } catch {
                print("이미지 다운로드 실패: \(error)")
                return nil
            }
        }
        .value

        guard let loadedImage else {
            self.photo = UIImage()
            
            return
        }

        self.photo = loadedImage
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
            let imageRequest = PostImageRequest(image: self.photo)
            let imageURL = try await STService.shared.imageService.uploadImage(imageRequest)
            self.imageURL = imageURL.imageUrl
        } catch {
            isFailed = true
            throw error
        }
    }
}
