//
//  NavigationState.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/6/25.
//

import SwiftUI
import Observation

// MARK: - Destinations

enum HomeModalNavigationDestination: Hashable {
    case staccatoDetail(_ staccatoID: Int64)
    case staccatoAdd
    case categoryDetail
    case categoryAdd
}


// MARK: - Navigation States

@Observable
class HomeModalNavigationState {
    var path = NavigationPath()
    var lastDestination: HomeModalNavigationDestination?
    
    func navigate(to destination: HomeModalNavigationDestination) {
        // NOTE: 지도 마커 클릭하여 스타카토 -> 스타카토로 가는 경우, 스타카토 경로를 누적하지 않음
        if case .staccatoDetail = destination,
           case .staccatoDetail = lastDestination {
            if path.count > 0 {
                path.removeLast()
            }
            path.append(destination)
            lastDestination = destination
        } else {
            path.append(destination)
            lastDestination = destination
        }
    }
}
