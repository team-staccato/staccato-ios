//
//  CameraView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/9/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented

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
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
}
