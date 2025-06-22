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
    
    // MARK: - Editor Type
    enum CategoryEditorType {
        case modify
        case create
    }

    // MARK: - CategoryDetail
    let categoryDetail: CategoryDetailModel?

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

    // MARK: - Color
    var isColorPalettePresented = false
    var categoryColor: CategoryColorType = .grayLight
    var categoryColorTemp: CategoryColorType = .grayLight

    // MARK: - Period
    var isPeriodSettingActive = false
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var isPeriodSheetPresented = false

    // MARK: - Share
    var isShareSettingActive = false

    // MARK: - Alert
    var catchError = false
    var errorTitle: String?
    var errorMessage: String?
    var uploadSuccess = false

    // MARK: - Modifying
    var id: Int64?
    var editorType: CategoryEditorType = .create
    private let categoryViewModel: CategoryViewModel
    
    private var lastAPICallTime: Date = .distantPast
    private let throttleInterval: TimeInterval = 2.0

    init(
        categoryDetail: CategoryDetailModel? = nil,
        editorType: CategoryEditorType = .create,
        categoryViewModel: CategoryViewModel
    ) {
        self.categoryDetail = categoryDetail

        self.id = categoryDetail?.categoryId
        self.categoryViewModel = categoryViewModel
        self.categoryColor = categoryDetail?.categoryColor ?? .gray

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

    func saveCategory(_ type: CategoryEditorType, completion: ((Int64?) -> Void)? = nil) async {
        let now = Date()
        let timeSinceLastCall = now.timeIntervalSince(lastAPICallTime)
        
        guard timeSinceLastCall >= throttleInterval else { return }
        
        lastAPICallTime = now
        
        switch type {
        case .create:
            await completion?(createCategory())
        case .modify:
            await modifyCategory()
        }
    }
    
    private func createCategory() async -> Int64? {
        let startAt: String? = isPeriodSettingActive ? selectedStartDate?.formattedAsRequestDate : nil
        let endAt: String? = isPeriodSettingActive ? selectedEndDate?.formattedAsRequestDate : nil
        
        let body = PostCategoryRequest(
            categoryThumbnailUrl: self.imageURL,
            categoryTitle: self.categoryTitle,
            description: self.categoryDescription,
            categoryColor: self.categoryColor.serverKey,
            startAt: startAt,
            endAt: endAt,
            isShared: self.isShareSettingActive
        )

        do {
            let response = try await STService.shared.categoryService.postCategory(body)
            try await categoryViewModel.getCategoryList()
            self.uploadSuccess = true
            return response.categoryId
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
            return nil
        }
    }

    private func modifyCategory() async {
        let startAt: String? = isPeriodSettingActive ? selectedStartDate?.formattedAsRequestDate : nil
        let endAt: String? = isPeriodSettingActive ? selectedEndDate?.formattedAsRequestDate : nil

        let query = PutCategoryRequest(
            categoryThumbnailUrl: self.imageURL,
            categoryTitle: self.categoryTitle,
            description: self.categoryDescription,
            categoryColor: self.categoryColor.serverKey,
            startAt: startAt,
            endAt: endAt
        )

        guard let id = self.id else { return }

        do {
            try await STService.shared.categoryService.putCategory(id: id, query)
            self.uploadSuccess = true
            try await categoryViewModel.getCategoryList()
            await categoryViewModel.getCategoryDetail(id)
        } catch {
            errorMessage = error.localizedDescription
            catchError = true
        }
    }
}
