//
//  Ex+Font.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

enum StaccatoFontFamily: String {
    case bold = "PretendardVariable-Bold"
    case semibold = "PretendardVariable-SemiBold"
    case regular = "PretendardVariable-Regular"
    case medium = "PretendardVariable-Medium"
}

enum StaccatoFont {
    case title1, title2, title3, body1, body2, body3, body4, body5

    var font: Font {
        switch self {
        case .title1:
                .custom(StaccatoFontFamily.bold.rawValue, size: self.size)
        case .title2:
                .custom(StaccatoFontFamily.bold.rawValue, size: self.size)
        case .title3:
                .custom(StaccatoFontFamily.semibold.rawValue, size: self.size)
        case .body1:
                .custom(StaccatoFontFamily.regular.rawValue, size: self.size)
        case .body2:
                .custom(StaccatoFontFamily.medium.rawValue, size: self.size)
        case .body3:
                .custom(StaccatoFontFamily.regular.rawValue, size: self.size)
        case .body4:
                .custom(StaccatoFontFamily.regular.rawValue, size: self.size)
        case .body5:
                .custom(StaccatoFontFamily.regular.rawValue, size: self.size)
        }
    }

    var size: CGFloat {
        switch self {
        case .title1:
            return 20
        case .title2:
            return 16
        case .title3:
            return 14
        case .body1:
            return 17
        case .body2:
            return 15
        case .body3:
            return 14
        case .body4:
            return 13
        case .body5:
            return 10
        }
    }

    var kerning: CGFloat {
        return -(self.size * 0.02)
    }

    var lineSpacing: CGFloat {
        switch self {
        case .title1, .title2, .body1, .body2:
            return 20 - self.size
        case .body3:
            return 18 - self.size
        case .title3, .body4, .body5:
            return 0
        }
    }
}

extension Font {
    // MARK: - Title
    static let title1: Font = .custom(StaccatoFontFamily.bold.rawValue, size: 20)
    static let title2: Font = .custom(StaccatoFontFamily.bold.rawValue, size: 16)
    static let title3: Font = .custom(StaccatoFontFamily.semibold.rawValue, size: 14)

    // MARK: - Body
    static let body1: Font = .custom(StaccatoFontFamily.regular.rawValue, size: 17)
    static let body2: Font = .custom(StaccatoFontFamily.medium.rawValue, size: 15)
    static let body3: Font = .custom(StaccatoFontFamily.regular.rawValue, size: 14)
    static let body4: Font = .custom(StaccatoFontFamily.regular.rawValue, size: 13)
    static let body5: Font = .custom(StaccatoFontFamily.regular.rawValue, size: 10)
}
