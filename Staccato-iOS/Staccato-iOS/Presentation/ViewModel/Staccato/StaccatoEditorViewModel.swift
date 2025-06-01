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
class StaccatoEditorViewModel {
    let editorMode: StaccatoEditorMode
    let isShared: Bool // TODO: 플래그 수정 필요. 서버와 논의중

    var title: String = ""
    var showDatePickerSheet = false
    var selectedDate: Date? = nil

    var catchError: Bool = false
    var errorTitle: String?
    var errorMessage: String?

    var photos: [UploadablePhoto] = []
    var isPhotoInputPresented = false
    var showCamera = false
    var isPhotoPickerPresented = false
    var photoItem: PhotosPickerItem? = nil

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

//    var categories: [CategoryModel] = []
//    var selectedCategory: CategoryModel?
    var categories: [CategoryCandidateModel] = []
    var selectedCategory: CategoryCandidateModel?

    var uploadSuccess = false

    // Create
    init(selectedCategory: CategoryCandidateModel? = nil, isShared: Bool = false) {
        self.editorMode = .create
        self.selectedCategory = selectedCategory
        self.selectedDate = .now
        self.isShared = isShared
        getCategoriesCandidates()
    }

    // Modify
    init(staccato: StaccatoDetailModel, isShared: Bool = false) {
        self.editorMode = .modify(id: staccato.staccatoId)
        self.isShared = isShared
        getPhotos(urls: staccato.staccatoImageUrls)
        getCategoriesCandidates(selectedCategoryId: staccato.categoryId)

        self.title = staccato.staccatoTitle
        self.selectedPlace = StaccatoPlaceModel(
            name: staccato.placeName,
            address: staccato.address,
            coordinate: CLLocationCoordinate2D(latitude: staccato.latitude, longitude: staccato.longitude)
        )
        self.selectedDate = Date(fromISOString: staccato.visitedAt)
    }

    func loadTransferable(from imageSelection: PhotosPickerItem?) async {
        do {
            if let imageData = try await imageSelection?.loadTransferable(type: Data.self),
               let transferedImage = UIImage(data: imageData) {
                self.photos.append(UploadablePhoto(photo: transferedImage))
                self.photoItem = nil
            }
        } catch {
            print(error.localizedDescription)
            errorTitle = "이미지 업로드 실패"
            errorMessage = error.localizedDescription
            catchError = true
        }
    }

    func createStaccato() async {
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
    }

    func modifyStaccato(staccatoId: Int64) async {
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
    }

    func getCategoriesCandidates(selectedCategoryId: Int64? = nil) {
        Task {
            let selectedDate = selectedDate ?? Date()
            let request = GetCategoriesCandidatesRequestQuery(
                specificDate: selectedDate.formattedAsRequestDate,
                isShared: isShared
            )
            do {
                let categoryList = try await STService.shared.categoryService.getCategoriesCandidates(request)
                let categories = categoryList.categories.map { CategoryCandidateModel(from: $0) }
                
                self.categories = categories
                
                if let selectedCategoryId {
                    self.selectedCategory = self.categories.first(where: { $0.categoryId == selectedCategoryId })
                }
            } catch {
                self.catchError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }

//    func getCategoryList(selectedCategoryId: Int64? = nil) {
//        Task {
//            do {
//                let categoryList = try await STService.shared.categoryService.getCategoryList(
//                    GetCategoryListRequestQuery(filters: nil, sort: nil)
//                )
//
//                let categories = categoryList.categories.map {
//                    CategoryModel(from: $0)
//                }
//
//                self.categories = categories
//
//                if let selectedCategoryId {
//                    self.selectedCategory = self.categories.first(where: { $0.categoryId == selectedCategoryId })
//                }
//            } catch {
//                self.catchError = true
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }

    func getPhotos(urls: [String]) {
        Task {
            for url in urls {
                photos.append(await UploadablePhoto(imageUrl: url))
            }
        }
    }
}

extension StaccatoEditorViewModel {
    enum StaccatoEditorMode: Equatable {
        case modify(id: Int64)
        case create
    }
}
