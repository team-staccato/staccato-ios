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
    case putComment(_ commentId: Int64, _ requestBody: PutCommentRequest)
    case deleteComment(_ commentId: Int64)
    
}


extension CommentEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .putComment(let commentId, _): return "/comments/\(commentId)"
        case .deleteComment(let commentId): return "/comments/\(commentId)"
        default: return "/comments"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComments: return .get
        case .postComment: return .post
        case .putComment: return .put
        case .deleteComment: return .delete
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getComments: return URLEncoding.queryString
        case .postComment: return JSONEncoding.default
        case .putComment: return JSONEncoding.default
        case .deleteComment: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getComments(let staccatoId): return ["staccatoId" : staccatoId]
        case .postComment(let requestBody): return requestBody.toDictionary()
        case .putComment(_, let requestBody): return requestBody.toDictionary()
        case .deleteComment(let commentId): return ["commentId" : commentId]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }
    
}
