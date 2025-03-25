//
//  CommentEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/25/25.
//

import Alamofire

enum CommentEndpoint {
    
    case getComments(_ staccatoId: Int64)
    
}


extension CommentEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        default: return "/comments/v2"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComments: return .get
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getComments: return URLEncoding.queryString
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getComments(let staccatoId): return ["staccatoId" : staccatoId]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getComments: return HeaderType.tokenOnly()
        }
    }
    
}
