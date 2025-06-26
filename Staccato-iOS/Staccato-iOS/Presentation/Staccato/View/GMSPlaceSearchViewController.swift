//
//  GMSPlaceSearchViewRepresentable.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/24/25.
//

import SwiftUI

import GooglePlaces

struct GMSPlaceSearchViewController: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    var onPlaceSelected: (StaccatoPlaceModel) -> Void

    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.placeFields = [.name, .formattedAddress, .coordinate]
        autocompleteController.delegate = context.coordinator
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}

}


// MARK: - Coordinator

extension GMSPlaceSearchViewController {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var parent: GMSPlaceSearchViewController

        init(_ parent: GMSPlaceSearchViewController) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            let selectedPlace = StaccatoPlaceModel(
                name: place.name ?? "알 수 없음",
                address: place.formattedAddress ?? "알 수 없음",
                coordinate: place.coordinate
            )
            parent.onPlaceSelected(selectedPlace)
            parent.presentationMode.wrappedValue.dismiss()
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("❌ Autocomplete error: \(error.localizedDescription)")
            parent.presentationMode.wrappedValue.dismiss()
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

}


// MARK: - Preview

#Preview {
    @Previewable @State var showingPlaceSearch = false
    @Previewable @State var selectedPlace: StaccatoPlaceModel?

    VStack(spacing: 10) {
        if let place = selectedPlace {
            Text(place.name).foregroundStyle(.blue).typography(.title1)
            Text("주소: \(place.address)").multilineTextAlignment(.center)
            Text("좌표: \(place.coordinate.latitude), \(place.coordinate.longitude)").foregroundStyle(.gray4)
        } else {
            Text("No place selected").foregroundStyle(.gray4)
        }

        Button("장소 검색하기") {
            showingPlaceSearch = true
        }
        .buttonStyle(.staccatoCapsule(icon: .magnifyingGlass, font: .title2))
        .padding(.top, 30)
    }
    .padding(.horizontal, 20)
    .sheet(isPresented: $showingPlaceSearch) {
        GMSPlaceSearchViewController { place in
            selectedPlace = place
        }
    }
}
