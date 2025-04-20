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
    var title: String = ""
    var locationManager = LocationManager()
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

    var isUploading = false

    func loadTransferable(from imageSelection: PhotosPickerItem?) async {
        do {
            if let imageData = try await imageSelection?.loadTransferable(type: Data.self),
               let transferedImage = UIImage(data: imageData) {
                await self.photos.append(UploadablePhoto(photo: transferedImage))
                self.photoItem = nil
            }
        } catch {
            print(error.localizedDescription)
            errorTitle = "이미지 업로드 실패"
            errorMessage = error.localizedDescription
            catchError = true
        }
    }
}
