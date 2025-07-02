//
//  GMUClusterItemWrapper.swift
//  Staccato-iOS
//
//  Created by 김유림 on 7/1/25.
//

import Foundation

import GoogleMapsUtils

final class GMUClusterItemWrapper: NSObject, GMUClusterItem {

    let staccato: StaccatoCoordinateModel
    var position: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: staccato.latitude, longitude: staccato.longitude) }

    init(_ staccato: StaccatoCoordinateModel) {
        self.staccato = staccato
    }

}
