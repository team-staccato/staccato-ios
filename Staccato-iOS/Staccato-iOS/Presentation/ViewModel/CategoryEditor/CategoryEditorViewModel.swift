//
//  CategoryEditorViewModel.swift
//  Staccato-iOS
//
//  Created by 정승균 on 3/24/25.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class CategoryEditorViewModel {
    // MARK: - Photo Related
    var isPhotoInputPresented = false
    var isPhotoPickerPresented = false
    var showCamera = false
    var photoItem: PhotosPickerItem?
    var selectedPhoto: UIImage?
    var imageURL: String?

    // MARK: - Title
    var categoryTitle = ""

    // MARK: - Description
    var categoryDescription = ""

    // MARK: - Period
    var isPeriodSettingActive = false
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var isPeriodSheetPresented = false

    // MARK: - Alert
    var catchError = false
    var errorTitle: String?
    var errorMessage: String?
    var uploadSuccess = false

    // MARK: - Modifying
    var id: Int64?
    var editorType: CategoryEditorType = .create

    init(categoryDetail: CategoryDetailModel? = nil, editorType: CategoryEditorType = .create) {
        self.id = categoryDetail?.categoryId

        if let imageURL = categoryDetail?.categoryThumbnailUrl {
            self.imageURL = imageURL
            self.getImage(imageURL)
        }

        self.categoryDescription = categoryDetail?.description ?? ""
        self.categoryTitle = categoryDetail?.categoryTitle ?? ""

        if let startAt = categoryDetail?.startAt,
           let endAt = categoryDetail?.endAt {
            self.selectedStartDate = Date.fromString(startAt)
            self.selectedEndDate = Date.fromString(endAt)
            self.isPeriodSettingActive = true
        }

        self.editorType = editorType
    }

    var categoryPeriod: String? {
        guard let selectedStartDate, let selectedEndDate else { return nil }
        return "\(selectedStartDate.formattedAsFullDate + " ~ " + selectedEndDate.formattedAsFullDate)"
    }

    var isSubmitButtonDisabled: Bool {
        return categoryTitle.isEmpty || (isPeriodSettingActive && categoryPeriod == nil)
    }

    // MARK: - Methods
    func loadTransferable(from imageSelection: PhotosPickerItem?) async {
        do {
            if let imageData = try await imageSelection?.loadTransferable(type: Data.self) {
                selectedPhoto = UIImage(data: imageData)
            }
        } catch {
            errorTitle = "이미지 업로드 실패"
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    func uploadImage() async throws {
       
        do {
            let requestBody = PostImageRequest(image: selectedPhoto)
            let imageUrl = try await STService.shared.imageService.uploadImage(requestBody)
            self.imageURL = imageUrl.imageUrl
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    func createCategory() async {
        let query = CreateCategoryRequestQuery(
            categoryThumbnailUrl: self.imageURL,
            categoryTitle: self.categoryTitle,
            description: self.categoryDescription,
            startAt: self.selectedStartDate?.formattedAsRequestDate ?? "",
            endAt: self.selectedEndDate?.formattedAsRequestDate ?? ""
        )

        do {
            try await STService.shared.categoryService.createCategory(query)
            self.uploadSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    func modifyCategory() async {
        let query = ModifyCategoryRequestQuery(
            categoryThumbnailUrl: self.imageURL,
            categoryTitle: self.categoryTitle,
            description: self.categoryDescription,
            startAt: self.selectedStartDate?.formattedAsRequestDate ?? "",
            endAt: self.selectedEndDate?.formattedAsRequestDate ?? ""
        )

        guard let id = self.id else { return }

        do {
            try await STService.shared.categoryService.modifyCategory(id: id, query)
            self.uploadSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    func getImage(_ url: String) {
        Task {
            guard let url = URL(string: url) else {
                self.selectedPhoto = nil
                return
            }

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

            self.selectedPhoto = loadedImage
        }
    }

    enum CategoryEditorType {
        case modify
        case create
    }
}
