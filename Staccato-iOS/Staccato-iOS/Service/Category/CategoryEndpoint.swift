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
    case deleteCategory(_ categoryId: Int64)
    case uploadImage
}

extension CategoryEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getCategoryList, .createCategory:
            return "/categories"
        case .getCategoryDetail(let categoryId),
             .deleteCategory(let categoryId):
            return "/categories/\(categoryId)"
        case .uploadImage:
            return "/categories/images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryList, .getCategoryDetail:
            return .get
        case .createCategory, .uploadImage:
            return .post
        case .deleteCategory:
            return .delete
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getCategoryList, .getCategoryDetail, .deleteCategory:
            return URLEncoding.queryString
        case .createCategory:
            return JSONEncoding.default
        case .uploadImage:
            return URLEncoding.default // multipart 용도일 경우 따로 처리 필요
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
        case .uploadImage:
            return nil
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
