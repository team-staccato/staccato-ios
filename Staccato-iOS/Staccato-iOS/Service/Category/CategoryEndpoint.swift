//
//  CategoryEndpoint.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Alamofire

enum CategoryEndpoint {
    case getCategoryList(_ query: GetCategoryListRequestQuery)
    case getCategoryCandidates(_ query: GetCategoryCandidatesRequestQuery)
    case getCategoryDetail(_ categoryId: Int64)
    case postCategory(_ requestBody: PostCategoryRequest)
    case putCategory(_ query: PutCategoryRequest, id: Int64)
    case deleteCategory(_ categoryId: Int64)
}

extension CategoryEndpoint: APIEndpoint {

    var path: String {
        switch self {
        case .getCategoryList:
            return "/v3/categories"
        case .getCategoryCandidates:
            return "/categories/candidates"
        case .getCategoryDetail(let categoryId):
            return "/v3/categories/\(categoryId)"
        case .postCategory:
            return "/v3/categories"
        case .putCategory(_, let categoryId):
            return "/v2/categories/\(categoryId)"
        case .deleteCategory(let categoryId):
            return "/categories/\(categoryId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .putCategory: return .put
        case .getCategoryList, .getCategoryCandidates, .getCategoryDetail:
            return .get
        case .postCategory:
            return .post
        case .deleteCategory:
            return .delete
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getCategoryList, .getCategoryCandidates, .getCategoryDetail, .deleteCategory:
            return URLEncoding.queryString
        case .postCategory, .putCategory:
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
        case .getCategoryCandidates(let query):
            return query.toDictionary()
        case .postCategory(let body):
            return body.toDictionary()
        case .putCategory(let body, _):
            return body.toDictionary()
        default:
            return nil
        }
    }

    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
