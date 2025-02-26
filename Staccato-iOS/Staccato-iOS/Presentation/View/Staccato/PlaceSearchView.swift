//
//  PlaceSearchView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/20/25.
//

// - MARK: Places Test Code
import SwiftUI
import CoreLocation
import GooglePlacesSwift
import UIKit
import GooglePlaces

struct PlaceSearchView: View {
    var body: some View {
        Text("Hello, World!")
            .task {
                let placesClient = PlacesClient.shared

                let center = CLLocation(37.3913916, -122.0879074)
                let northEast = CLLocationCoordinate2D(37.388162, -122.088137)
                let southWest = CLLocationCoordinate2D(37.395804, -122.077023)

                let bias = RectangularCoordinateRegion(northEast: northEast, southWest: southWest)
                let filter = AutocompleteFilter(types: [ .restaurant ], origin: center, coordinateRegionBias: bias)

                let autocompleteRequest = AutocompleteRequest(query: "Sicilian piz", filter: filter)
                switch await placesClient.fetchAutocompleteSuggestions(with: autocompleteRequest) {
                case .success(let autocompleteSuggestions):
                    print(autocompleteSuggestions)
                case .failure(let placesError):
                    print("error")
                    print(placesError)
                }
            }
    }
}

#Preview {
    PlaceSearchView()
}

extension CLLocationCoordinate2D {
    init(_ latitude: Double, _ longitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocation {
    convenience init(_ latitude: Double, _ longitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
    }
}
