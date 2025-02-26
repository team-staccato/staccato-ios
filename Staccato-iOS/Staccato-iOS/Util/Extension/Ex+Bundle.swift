//
//  Ex+Bundle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/14/25.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }
}
