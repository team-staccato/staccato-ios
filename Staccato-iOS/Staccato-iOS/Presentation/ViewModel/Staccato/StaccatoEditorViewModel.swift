//
//  StaccatoCreateViewModel.swift
//  Staccato-iOS
//
//  Created by 정승균 on 4/20/25.
//
import Foundation
import SwiftUI
import PhotosUI

@Observable
final class StaccatoEditorViewModel {

    enum StaccatoEditorMode: Equatable {
        case create
        case modify(id: Int64)
    }

    let editorMode: StaccatoEditorMode
    let isSharedStaccato: Bool

    var title: String = ""

    var showDatePickerSheet = false
    var dateOnDatePicker: Date? = nil
    var selectedDate: Date? = nil
    
    var catchError: Bool = false
    var errorTitle: String?
    var errorMessage: String?

    var photos: [UploadablePhoto] = []
    var draggedPhoto: UploadablePhoto?
    var selectedPhotos: [PhotosPickerItem] = []
    var showCamera = false
    var isPhotoInputPresented = false
    var isPhotoPickerPresented = false

    var showPlaceSearchSheet = false
    var selectedPlace: StaccatoPlaceModel?

    var isReadyToSave: Bool {
        return !title.isEmpty &&
        selectedPlace?.name.isEmpty == false &&
        selectedPlace?.address.isEmpty == false &&
        selectedPlace?.coordinate.latitude != nil &&
        selectedPlace?.coordinate.longitude != nil &&
        selectedDate != nil
    }

    var categories: [CategoryCandidateModel] = []
    var selectedCategory: CategoryCandidateModel?

    var uploadSuccess = false
    
    var isSaving = false
    private var lastAPICallTime: Date = .distantPast
    private let throttleInterval: TimeInterval = 2.0

    /// Create Staccato
    init(selectedCategory: CategoryCandidateModel? = nil) {
        self.editorMode = .create
        self.isSharedStaccato = false
        self.selectedDate = .now
        self.dateOnDatePicker = selectedDate
        self.selectedCategory = selectedCategory

        getCategoryCandidates()
    }

    /// Modify Staccato
    init(staccato: StaccatoDetailModel) {
        self.editorMode = .modify(id: staccato.staccatoId)
        self.isSharedStaccato = staccato.isShared

        self.title = staccato.staccatoTitle
        self.selectedPlace = StaccatoPlaceModel(
            name: staccato.placeName,
            address: staccato.address,
            coordinate: CLLocationCoordinate2D(latitude: staccato.latitude, longitude: staccato.longitude)
        )
        self.selectedDate = Date(fromISOString: staccato.visitedAt)
        self.dateOnDatePicker = selectedDate
        self.selectedCategory = CategoryCandidateModel(
            categoryId: staccato.categoryId,
            categoryTitle: staccato.categoryTitle
        )

        getPhotos(urls: staccato.staccatoImageUrls)
        getCategoryCandidates()
    }

    func loadTransferable() {
        Array(0..<selectedPhotos.count).forEach { _ in
            photos.append(UploadablePhoto())
        }

        Task {
            await withTaskGroup(of: UIImage.self) { group in
                for selectedPhoto in selectedPhotos {
                    group.addTask {
                        do {
                            if let imageData = try await selectedPhoto.loadTransferable(type: Data.self),
                               let transferedImage = UIImage(data: imageData) {
                                return transferedImage
                            }
                        } catch let error {
                            self.errorTitle = "이미지 업로드 실패"
                            self.errorMessage = error.localizedDescription
                            self.catchError = true
                        }
                        return UIImage()
                    }
                }

                for await image in group {
                    if !photos.contains(where: { $0.photo.pngData() == image.pngData() }) {
                        await MainActor.run {
                            if let uploadablePhoto = photos.first(where: { $0.photo == UIImage(resource: .categoryThumbnailDefault) }) {
                                uploadablePhoto.photo = image
                                Task.detached(priority: .high) { try await uploadablePhoto.uploadImage() }
                            }
                        }
                    } else {
                        photos.removeLast()
                    }
                }
            }

            selectedPhotos.removeAll()
        }
    }

}


// MARK: - Network

extension StaccatoEditorViewModel {
    
    func saveStaccato(_ type: StaccatoEditorMode) async {
        guard !isSaving else { return }
        
        let now = Date()
        let timeSinceLastCall = now.timeIntervalSince(lastAPICallTime)
        
        guard timeSinceLastCall >= throttleInterval else { return }
        
        lastAPICallTime = now
        
        switch type {
        case .create:
            await createStaccato()
        case .modify(let staccatoId):
            await modifyStaccato(staccatoId: staccatoId)
        }
    }
    
    private func createStaccato() async {
        isSaving = true
        
        guard let selectedCategoryId = self.selectedCategory?.categoryId else {
            self.catchError = true
            self.errorMessage = "유효한 카테고리를 선택해주세요."
            return
        }

        let request = PostStaccatoRequest(
            staccatoTitle: self.title,
            placeName: self.selectedPlace?.name ?? "",
            address: self.selectedPlace?.address ?? "",
            latitude: self.selectedPlace?.coordinate.latitude ?? 0.0,
            longitude: self.selectedPlace?.coordinate.longitude ?? 0.0,
            visitedAt: self.selectedDate?.formattedAsISO8601 ?? "",
            categoryId: selectedCategoryId,
            staccatoImageUrls: photos.compactMap { return $0.imageURL }
        )

        do {
            try await STService.shared.staccatoService.postStaccato(request)
            self.uploadSuccess = true
        } catch {
            self.catchError = true
            self.errorMessage = error.localizedDescription
        }
        
        isSaving = false
    }

    private func modifyStaccato(staccatoId: Int64) async {
        isSaving = true
        
        guard let selectedCategoryId = self.selectedCategory?.categoryId else {
            self.catchError = true
            self.errorMessage = "유효한 카테고리를 선택해주세요."
            return
        }

        let request = PutStaccatoRequest(
            staccatoTitle: self.title,
            placeName: self.selectedPlace?.name ?? "",
            address: self.selectedPlace?.address ?? "",
            latitude: self.selectedPlace?.coordinate.latitude ?? 0.0,
            longitude: self.selectedPlace?.coordinate.longitude ?? 0.0,
            visitedAt: self.selectedDate?.formattedAsISO8601 ?? "",
            categoryId: selectedCategoryId,
            staccatoImageUrls: photos.compactMap { return $0.imageURL }
        )

        do {
            try await STService.shared.staccatoService.putStaccato(staccatoId, requestBody: request)
            self.uploadSuccess = true
        } catch {
            self.catchError = true
            self.errorMessage = error.localizedDescription
        }
        
        isSaving = false
    }

    func getCategoryCandidates() {
        Task {
            let selectedDate = selectedDate ?? Date()
            let request = GetCategoryCandidatesRequestQuery(
                specificDate: selectedDate.formattedAsRequestDate,
                isPrivate: editorMode != .create
            )
            do {
                let categoryList = try await STService.shared.categoryService.getCategoryCandidates(request)
                let categories = categoryList.categories.map { CategoryCandidateModel(from: $0) }

                self.categories = categories

                // selectedCategory 갱신
                if !isSharedStaccato,
                   let selectedCategoryId = self.selectedCategory?.categoryId {
                    self.selectedCategory = self.categories.first(where: { $0.categoryId == selectedCategoryId })
                }
            } catch {
                self.catchError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }

}


// MARK: - Helper

private extension StaccatoEditorViewModel {

    func getPhotos(urls: [String]) {
        Task {
            for url in urls {
                photos.append(await UploadablePhoto(imageUrl: url))
            }
        }
    }

}
