//
//  CameraView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/9/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    let cameraMode: CameraMode
    @Binding var selectedImage: UIImage?
    @Binding var imageList: [UIImage]
    @Environment(\.presentationMode) var isPresented

    init(
        cameraMode: CameraMode = .single,
        selectedImage: Binding<UIImage?> = .constant(nil),
        imageList: Binding<[UIImage]> = .constant([])
    ) {
        self.cameraMode = cameraMode
        self._selectedImage = selectedImage
        self._imageList = imageList
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: CameraView

        init(picker: CameraView) {
            self.picker = picker
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }

            switch self.picker.cameraMode {
            case .single:
                self.picker.selectedImage = selectedImage
            case .multiple:
                self.picker.imageList.append(selectedImage)
            }
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }

    enum CameraMode {
        case single
        case multiple
    }
}
