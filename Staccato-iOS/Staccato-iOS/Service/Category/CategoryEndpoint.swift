//
//  CategoryEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Alamofire

enum CategoryEndpoint {
    
    case getCategoryList(_ query: GetCategoryListRequestQuery)
    
    case createCategory(_ query: CreateCategoryRequestQuery)
}


extension CategoryEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getCategoryList, .createCategory: return "/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryList: return .get
        case .createCategory: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getCategoryList: return URLEncoding.queryString
        case .createCategory: return JSONEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getCategoryList(let query):
            var params: [String: Any] = [:]
            if let filters = query.filters {
                params["filters"] = filters
            }
            if let sort = query.sort {
                params["sort"] = sort
            }
            return params.isEmpty ? nil : params
        case .createCategory(let query):
            return query.toDictionary()
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCategoryList, .createCategory: return HeaderType.tokenOnly()
        }
    }
}
