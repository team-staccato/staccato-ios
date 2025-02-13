//
//  NetworkError.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown
}
