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
    
    case uploadImage
}


extension CategoryEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getCategoryList, .createCategory: return "/categories"
        case .uploadImage: return "images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryList: return .get
        case .createCategory, .uploadImage: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getCategoryList: return URLEncoding.queryString
        case .createCategory: return JSONEncoding.default
        case .uploadImage: return URLEncoding.default
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
        case .uploadImage: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCategoryList, .createCategory, .uploadImage: return HeaderType.tokenOnly()
        }
    }
}
