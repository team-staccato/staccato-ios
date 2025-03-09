//
//  CategoryEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Alamofire

enum CategoryEndpoint {
    
    case getCategoryList(_ query: GetCategoryListRequestQuery)
    
}


extension CategoryEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getCategoryList: return "/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryList: return .get
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCategoryList: return HeaderType.token()
        }
    }
    
}
