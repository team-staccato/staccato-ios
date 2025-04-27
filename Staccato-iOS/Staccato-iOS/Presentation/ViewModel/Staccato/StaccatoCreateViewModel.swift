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
class StaccatoCreateViewModel {
    var categoryId: Int?
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


    init(categoryId: Int? = nil) {
        self.categoryId = categoryId
        self.title = ""
        self.showDatePickerSheet = false
        self.selectedDate = nil
        self.catchError = false
        self.errorTitle = nil
        self.errorMessage = nil
        self.photos = []
        self.isPhotoInputPresented = false
        self.showCamera = false
        self.isPhotoPickerPresented = false
        self.photoItem = nil
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
        let request = CreateStaccatoRequest(
            staccatoTitle: self.title,
            placeName: self.selectedPlace?.name ?? "",
            address: self.selectedPlace?.address ?? "",
            latitude: self.selectedPlace?.coordinate.latitude ?? 0.0,
            longitude: self.selectedPlace?.coordinate.longitude ?? 0.0,
            visitedAt: self.selectedDate?.formattedAsISO8601 ?? "",
            categoryID: self.categoryId ?? 0,
            staccatoImageUrls: photos.compactMap { return $0.imageURL }
        )

        do {
            try await STService.shared.staccatoService.createStaccato(request)
        } catch {
            self.catchError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
