//
//  CategoryEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Alamofire

enum CategoryEndpoint {
    case getCategoryList(_ query: GetCategoryListRequestQuery)
    case getCategoryDetail(_ categoryId: Int64)
    case createCategory(_ query: CreateCategoryRequestQuery)

    case modifyCategory(_ query: ModifyCategoryRequestQuery, id: Int)
    case deleteCategory(_ categoryId: Int64)
}

extension CategoryEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .modifyCategory(_, let id): return "/categories/\(id)"
        case .getCategoryList, .createCategory:
            return "/categories"
        case .getCategoryDetail(let categoryId),
             .deleteCategory(let categoryId):
            return "/categories/\(categoryId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .modifyCategory: return .put
        case .getCategoryList, .getCategoryDetail:
            return .get
        case .createCategory:
            return .post
        case .deleteCategory:
            return .delete
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getCategoryList, .getCategoryDetail, .deleteCategory:
            return URLEncoding.queryString
        case .createCategory, .modifyCategory:
            return JSONEncoding.default
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
        case .modifyCategory(let query, _):
            return query.toDictionary()
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
