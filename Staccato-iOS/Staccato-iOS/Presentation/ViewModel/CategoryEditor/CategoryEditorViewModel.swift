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

    // MARK: - Title
    var categoryTitle = ""

    // MARK: - Description
    var categoryDescription = ""

    // MARK: - Period
    var isPeriodSettingActive = false
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var isPeriodSheetPresented = false

    var categoryPeriod: String? {
        guard let selectedStartDate, let selectedEndDate else { return nil }
        return "\(selectedStartDate.formattedAsFullDate + " ~ " + selectedEndDate.formattedAsFullDate)"
    }

    var isSubmitButtonDisabled: Bool {
        return categoryTitle.isEmpty || (isPeriodSettingActive && categoryPeriod == nil)
    }

    // MARK: - Methods
    func loadTransferable(from imageSelection: PhotosPickerItem?) {
        Task {
            if let imageData = try? await imageSelection?.loadTransferable(type: Data.self) {
                selectedPhoto = UIImage(data: imageData)
            }
        }
    }

    func createCategory() {
        let query = CreateCategoryRequestQuery(
            categoryThumbnailUrl: "",
            categoryTitle: self.categoryTitle,
            description: self.categoryDescription ?? "",
            startAt: self.selectedStartDate?.formattedAsRequestDate ?? "",
            endAt: self.selectedEndDate?.formattedAsRequestDate ?? ""
        )
        Task {
            // 값 리턴 되면, 동작 정의 해야 함
            try await STService.shared.categoryServie.createCategory(query)
        }
    }
}
