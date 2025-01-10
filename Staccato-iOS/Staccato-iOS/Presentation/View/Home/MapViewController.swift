//
//  MapViewController.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import UIKit

class MapViewController: UIViewController {
    
    let map =  GMSMapView(frame: .zero)
    var isAnimating: Bool = false
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
}
