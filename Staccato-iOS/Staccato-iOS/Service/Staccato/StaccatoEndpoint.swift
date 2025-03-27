//
//  StaccatoEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Alamofire

enum StaccatoEndpoint {
    
    case getStaccatoList
    case postStaccatoFeeling(_ staccatoId: Int64, requestBody: PostStaccatoFeelingRequest)
    
}


extension StaccatoEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getStaccatoList: return "/staccatos"
        case .postStaccatoFeeling(let staccatoId, _):
            return "/staccatos/\(staccatoId)/feeling"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getStaccatoList: return .get
        case .postStaccatoFeeling: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getStaccatoList: return URLEncoding.default
        case .postStaccatoFeeling(_, let requestBody): return JSONEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .postStaccatoFeeling(_, let requestBody): return requestBody.toDictionary()
        default: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }
    
}
