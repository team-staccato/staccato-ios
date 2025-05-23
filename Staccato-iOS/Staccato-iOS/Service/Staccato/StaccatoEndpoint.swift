//
//  StaccatoEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Alamofire

enum StaccatoEndpoint {

    case getStaccatoList
    case getStaccatoDetail(_ staccatoId: Int64)

    case postStaccato(requestBody: PostStaccatoRequest)
    case postStaccatoFeeling(_ staccatoId: Int64, requestBody: PostStaccatoFeelingRequest)
    case postShareLink(_ staccatoId: Int64)

    case putStaccato(_ staccatoId: Int64, requestBody: PutStaccatoRequest)

    case delteStaccato(_ staccatoId: Int64)

}


extension StaccatoEndpoint: APIEndpoint {

    var path: String {
        switch self {
        case .getStaccatoList: return "/v2/staccatos"
        case .getStaccatoDetail(let staccatoId): return "/staccatos/\(staccatoId)"

        case .postStaccato: return "/staccatos"
        case .postStaccatoFeeling(let staccatoId, _): return "/staccatos/\(staccatoId)/feeling"
        case .postShareLink(let staccatoId): return "/staccatos/\(staccatoId)/share"

        case .putStaccato(let staccatoId, _): return "/staccatos/\(staccatoId)"

        case .delteStaccato(let staccatoId): return "/staccatos/\(staccatoId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getStaccatoList, .getStaccatoDetail:
            return .get

        case .postStaccatoFeeling, .postStaccato, .postShareLink:
            return .post

        case .putStaccato:
            return .put

        case .delteStaccato:
            return .delete
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getStaccatoList: return URLEncoding.default
        case .getStaccatoDetail: return URLEncoding.queryString

        case .postStaccatoFeeling: return JSONEncoding.default
        case .postStaccato: return JSONEncoding.default
        case .postShareLink: return JSONEncoding.default

        case .putStaccato: return JSONEncoding.default

        case .delteStaccato: return URLEncoding.queryString
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .postStaccatoFeeling(_, let requestBody): return requestBody.toDictionary()
        case .putStaccato(_, let requestBody): return requestBody.toDictionary()
        case .postStaccato(requestBody: let requestBody): return requestBody.toDictionary()
        default: return nil
        }
    }

    var headers: [String : String]? {
        switch self {
        default: return HeaderType.tokenOnly()
        }
    }

}
