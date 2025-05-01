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
    case delteStaccato(_ staccatoId: Int64)
    case getStaccatoDetail(_ staccatoId: Int64)
    case createStaccato(requestBody: CreateStaccatoRequest)
    case modifyStaccato(_ staccatoId: Int64, requestBody: ModifyStaccatoRequest)

}


extension StaccatoEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getStaccatoDetail(let staccatoId),
                .modifyStaccato(let staccatoId, _),
                .delteStaccato(let staccatoId):
            return "/staccatos/\(staccatoId)"
        case .getStaccatoList, .createStaccato: return "/staccatos"
        case .postStaccatoFeeling(let staccatoId, _): return "/staccatos/\(staccatoId)/feeling"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getStaccatoList: return .get
        case .getStaccatoDetail: return .get
        case .postStaccatoFeeling: return .post
        case .delteStaccato: return .delete
        case .createStaccato: return .post
        case .modifyStaccato: return .put
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getStaccatoList: return URLEncoding.default
        case .getStaccatoDetail, .delteStaccato: return URLEncoding.queryString
        case .postStaccatoFeeling: return JSONEncoding.default
        case .createStaccato: return JSONEncoding.default
        case .modifyStaccato: return JSONEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .postStaccatoFeeling(_, let requestBody): return requestBody.toDictionary()
        case .modifyStaccato(_, let requestBody): return requestBody.toDictionary()
        case .createStaccato(requestBody: let requestBody): return requestBody.toDictionary()
        default: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }
    
}
