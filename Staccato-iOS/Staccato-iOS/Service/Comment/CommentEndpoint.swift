//
//  CommentEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/25/25.
//

import Alamofire

enum CommentEndpoint {
    
    case getComments(_ staccatoId: Int64)
    case postComment(_ requestBody: PostCommentRequest)
    
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
        case .postComment: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getComments: return URLEncoding.queryString
        case .postComment: return JSONEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getComments(let staccatoId): return ["staccatoId" : staccatoId]
        case .postComment(let requestBody): return requestBody.encode()
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }
    
}
