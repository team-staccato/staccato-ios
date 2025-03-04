//
//  NetworkError.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation
import Network

enum NetworkError: Error {
    case invalidURL
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case payloadTooLarge
    case serverError
    case unknownError
}

final class ErrorHandler {
    static func handleError(_ response: HTTPURLResponse?) -> NetworkError {
        guard let statusCode = response?.statusCode else { return .unknownError }
        switch statusCode {
        case 400:
            return NetworkError.badRequest
        case 401:
            return NetworkError.unauthorized
        case 403:
            return NetworkError.forbidden
        case 404:
            return NetworkError.notFound
        case 413:
            return NetworkError.payloadTooLarge
        case 500...599:
            return NetworkError.serverError
        default:
            return NetworkError.unknownError
        }
    }
}
