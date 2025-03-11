//
//  NavigationState.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/6/25.
//

import SwiftUI
import Observation

// MARK: - Destinations

enum CategoryNavigationDestination {
    case staccatoDetail
    case staccatoAdd
    case categoryDetail
    case categoryAdd
}


// MARK: - Navigation States

@Observable
class CategoryNavigationState {
    var path = NavigationPath()
    
    func navigate(to destination: CategoryNavigationDestination) {
        path.append(destination)
    }
}
