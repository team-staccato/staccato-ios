//
//  NotificationEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 6/7/25.
//
import Alamofire

enum NotificationEndPoint {

    case getHasNotification

}


extension NotificationEndPoint: APIEndpoint {

    var path: String {
        switch self {
        case .getHasNotification: return "/notifications/exists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getHasNotification:
            return .get
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getHasNotification: return URLEncoding.default
        }
    }

    var parameters: [String : Any]? {
        switch self {
        default: return nil
        }
    }

    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }

}
