//
//  Ex+Image.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

extension Image {
    init(_ icon: StaccatoIcon) {
        self.init(systemName: icon.rawValue)
    }
}
