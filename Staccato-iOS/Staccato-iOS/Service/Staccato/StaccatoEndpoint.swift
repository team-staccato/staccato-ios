//
//  StaccatoEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Alamofire

enum StaccatoEndpoint {
    
    case getStaccatoList
    
}


extension StaccatoEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getStaccatoList: return "/staccatos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getStaccatoList: return .get
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getStaccatoList: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getStaccatoList: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getStaccatoList: return HeaderType.tokenOnly()
        }
    }
    
}
