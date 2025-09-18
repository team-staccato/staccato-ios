//
//  NavigationManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/6/25.
//

import SwiftUI
import Observation

// MARK: - Destinations

enum NavigationDestination: Hashable {
    case staccatoDetail(_ staccatoId: Int64)
    case categoryDetail(_ categoryId: Int64)
}


// MARK: - Navigation States

@Observable
final class NavigationManager {

    var path = NavigationPath()
    private(set) var destinations: [NavigationDestination] = []

    func navigate(to destination: NavigationDestination) {
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
