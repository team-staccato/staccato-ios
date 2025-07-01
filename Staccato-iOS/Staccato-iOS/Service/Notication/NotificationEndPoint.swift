//
//  NotificationEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 6/7/25.
//

import Alamofire

enum NotificationEndPoint {
    case postNotificationToken(_ token: String, _ deviceId: String)
    case getHasNotification
}

extension NotificationEndPoint: APIEndpoint {

    var path: String {
        switch self {
        case .postNotificationToken: return "/notifications/tokens"
        case .getHasNotification: return "/notifications/exists"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postNotificationToken:
            return .post
        case .getHasNotification:
            return .get
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postNotificationToken: return JSONEncoding.default
        case .getHasNotification: return URLEncoding.default
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .postNotificationToken(let token, let deviceId):
            return ["token": token, "deviceType": "iOS", "deviceId": deviceId]
        default: return nil
        }
    }

    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }

}
