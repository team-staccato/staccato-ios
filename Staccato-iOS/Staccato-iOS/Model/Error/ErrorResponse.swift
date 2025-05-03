//
//  ErrorResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/25/25.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: String
    let message: String
}
