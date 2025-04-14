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
final class NavigationState {

    var path = NavigationPath()
    private(set) var destinations: [HomeModalNavigationDestination] = []

    func navigate(to destination: HomeModalNavigationDestination) {
        if case .staccatoDetail = destination,
           case .staccatoDetail = destinations.last,
           !path.isEmpty {
            path.removeLast()
            destinations.removeLast()
        }
        path.append(destination)
        destinations.append(destination)
    }

    func dismiss() {
        guard !path.isEmpty else { return }
        path.removeLast()
        destinations.removeLast()
    }

    func dismissToRoot() {
        path.removeLast(path.count)
        destinations.removeAll()
    }

}
