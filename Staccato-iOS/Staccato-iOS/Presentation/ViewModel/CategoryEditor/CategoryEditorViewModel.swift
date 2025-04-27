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
    var id: Int?
    var editorType: CategoryEditorType = .create

    init(id: Int? = nil, editorType: CategoryEditorType = .create) {
        self.isPhotoInputPresented = false
        self.isPhotoPickerPresented = false
        self.showCamera = false
        self.photoItem = nil
        self.selectedPhoto = nil
        self.imageURL = nil
        self.categoryTitle = ""
        self.categoryDescription = ""
        self.isPeriodSettingActive = false
        self.selectedStartDate = nil
        self.selectedEndDate = nil
        self.isPeriodSheetPresented = false
        self.catchError = false
        self.errorTitle = nil
        self.errorMessage = nil
        self.uploadSuccess = false
        self.id = id
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

    func uploadImage() async {
        do {
            let imageURL = try await NetworkService.shared.uploadImage(selectedPhoto)
            self.imageURL = imageURL.imageUrl
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
            try await STService.shared.categoryServie.createCategory(query)
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
            try await STService.shared.categoryServie.modifyCategory(id: id, query)
            self.uploadSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    enum CategoryEditorType {
        case modify
        case create
    }
}
