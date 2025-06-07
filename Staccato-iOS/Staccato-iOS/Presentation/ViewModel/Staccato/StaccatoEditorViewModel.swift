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
        case modify(id: Int64)
        case create
    }
    
    let editorMode: StaccatoEditorMode
    
    var title: String = ""
    var showDatePickerSheet = false
    var selectedDate: Date? = nil
    
    var catchError: Bool = false
    var errorTitle: String?
    var errorMessage: String?
    
    var photos: [UploadablePhoto] = []
    var selectedPhotos: [PhotosPickerItem] = []
    var showCamera = false
    var isPhotoInputPresented = false
    var isPhotoPickerPresented = false
    var photosCount: Int { photos.count + selectedPhotos.count }
    
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
    
    var categories: [CategoryModel] = []
    var selectedCategory: CategoryModel?
    
    var uploadSuccess = false
    
    /// Create Staccato
    init(selectedCategory: CategoryModel? = nil) {
        self.editorMode = .create
        self.selectedCategory = selectedCategory
        self.selectedDate = .now
        getCategoryList()
    }
    
    /// Modify Staccato
    init(staccato: StaccatoDetailModel) {
        self.editorMode = .modify(id: staccato.staccatoId)
        getPhotos(urls: staccato.staccatoImageUrls)
        getCategoryList(selectedCategoryId: staccato.categoryId)
        
        self.title = staccato.staccatoTitle
        self.selectedPlace = StaccatoPlaceModel(
            name: staccato.placeName,
            address: staccato.address,
            coordinate: CLLocationCoordinate2D(latitude: staccato.latitude, longitude: staccato.longitude)
        )
        self.selectedDate = Date(fromISOString: staccato.visitedAt)
    }
    
    func loadTransferable() {
        Task {
            await withTaskGroup(of: UploadablePhoto?.self) { group in
                for selectedPhoto in selectedPhotos {
                    group.addTask {
                        do {
                            if let imageData = try await selectedPhoto.loadTransferable(type: Data.self),
                               let transferedImage = UIImage(data: imageData) {
                                return UploadablePhoto(photo: transferedImage)
                            }
                        } catch let error {
                            self.errorTitle = "이미지 업로드 실패"
                            self.errorMessage = error.localizedDescription
                            self.catchError = true
                        }
                        return nil
                    }
                }
                
                for await result in group {
                    if let photo = result,
                       !photos.contains(where: { $0.photo.pngData() == photo.photo.pngData() }) {
                        await MainActor.run {
                            self.photos.append(photo)
                        }
                    }
                }
            }
            
            selectedPhotos.removeAll()
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
}
    
private extension StaccatoEditorViewModel {
    
    func getCategoryList(selectedCategoryId: Int64? = nil) {
        Task {
            do {
                let categoryList = try await STService.shared.categoryService.getCategoryList(
                    GetCategoryListRequestQuery(filters: nil, sort: nil)
                )

                let categories = categoryList.categories.map {
                    CategoryModel(from: $0)
                }

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

    func getPhotos(urls: [String]) {
        Task {
            for url in urls {
                photos.append(await UploadablePhoto(imageUrl: url))
            }
        }
    }
}
