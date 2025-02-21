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

struct PlaceSearchView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                let placesClient = PlacesClient.shared
                
                let restriction: RectangularCoordinateRegion = RectangularCoordinateRegion(northEast: CLLocationCoordinate2D(latitude: 20, longitude: 30), southWest: CLLocationCoordinate2D(latitude: 40, longitude: 50))!

                let searchByTextRequest = SearchByTextRequest(
                        textQuery: "pizza in New York",
                        placeProperties: [ .displayName, .placeID ],
                        locationRestriction: restriction,
                        includedType: .restaurant,
                        maxResultCount: 5,
                        minRating: 3.5,
                        priceLevels: [ .moderate, .inexpensive ],
                        isStrictTypeFiltering: true
                )

                switch await placesClient.searchByText(with: searchByTextRequest) {
                case .success(let places):
                    print("결과")
                    print(places)
                case .failure(let placesError):
                    print("에러발생")
                    print(placesError)
                }
            }
    }
}

#Preview {
    PlaceSearchView()
}
