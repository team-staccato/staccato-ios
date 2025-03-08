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
    case badRequest(String)
    case unauthorized
    case forbidden
    case notFound
    case payloadTooLarge
    case serverError
    case unknownError
}

extension NetworkError: CustomStringConvertible {
    var description: String {
            switch self {
            case .invalidURL:
                return "❌ 유효하지 않은 URL입니다."
            case .badRequest:
                return "❌ 잘못된 요청입니다. (400 Bad Request)"
            case .unauthorized:
                return "❌ 인증이 필요합니다. (401 Unauthorized)"
            case .forbidden:
                return "❌ 접근 권한이 없습니다. (403 Forbidden)"
            case .notFound:
                return "❌ 요청한 리소스를 찾을 수 없습니다. (404 Not Found)"
            case .payloadTooLarge:
                return "❌ 요청한 데이터가 너무 큽니다. (413 Payload Too Large)"
            case .serverError:
                return "❌ 서버에서 오류가 발생했습니다. (500 Internal Server Error)"
            case .unknownError:
                return "❌ 알 수 없는 네트워크 오류가 발생했습니다."
            }
        }
}

final class ErrorHandler {
    static func handleError(_ response: HTTPURLResponse?, _ data: Data?) -> NetworkError {
        guard let statusCode = response?.statusCode else { return .unknownError }
        switch statusCode {
        case 400:
            guard let data = data,
                  let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            else {
                return .badRequest("잘못된 요청입니다.")
            }
            return .badRequest(errorResponse.message)
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
