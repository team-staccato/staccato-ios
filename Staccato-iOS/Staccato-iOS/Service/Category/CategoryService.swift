//
//  CategoryService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

protocol CategoryServiceProtocol {
    
    func getCategoryList(_ query: GetCategoryListRequestQuery,
                         completion: @escaping (GetCategoryListResponse) -> Void)
    
}

class CategoryService: CategoryServiceProtocol {
    
    func getCategoryList(_ query: GetCategoryListRequestQuery,
                         completion: @escaping (GetCategoryListResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: CategoryEndpoint.getCategoryList(query),
            responseType: GetCategoryListResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("😢 getCategoryList 실패 - \(error)")
            }
        }
    }
    
}
