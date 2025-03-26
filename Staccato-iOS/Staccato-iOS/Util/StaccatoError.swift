//
//  StaccatoError.swift
//  Staccato-iOS
//
//  Created by 정승균 on 3/16/25.
//

import Foundation

enum StaccatoError: LocalizedError {
    case optionalBindingFailed
    case imageParsingFailed
}

extension StaccatoError {
    var errorDescription: String? {
        switch self {
        case .optionalBindingFailed: "옵셔널 바인딩 실패"
        case .imageParsingFailed: "이미지 파싱 실패"
        }
    }
}
