//
//  CategoryService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

protocol CategoryServiceProtocol {

    func getCategoryList(_ query: GetCategoryListRequestQuery) async throws -> GetCategoryListResponse

    func getCategoryCandidates(_ query: GetCategoryCandidatesRequestQuery) async throws -> GetCategoryCandidatesResponse

    func getCategoryDetail(_ categoryId: Int64) async throws -> GetCategoryDetailResponse

    func postCategory(_ requestBody: PostCategoryRequest) async throws -> PostCategoryResponse

    func putCategory(id: Int64, _ query: PutCategoryRequest) async throws

    func deleteCategory(_ categoryId: Int64) async throws

}

class CategoryService: CategoryServiceProtocol {
    
    func getCategoryList(_ query: GetCategoryListRequestQuery) async throws -> GetCategoryListResponse {
        guard let categoryList = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.getCategoryList(query),
            responseType: GetCategoryListResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return categoryList
    }

    func getCategoryCandidates(_ query: GetCategoryCandidatesRequestQuery) async throws -> GetCategoryCandidatesResponse {
        guard let categoryList = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.getCategoryCandidates(query),
            responseType: GetCategoryCandidatesResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return categoryList
    }

    func getCategoryDetail(_ categoryId: Int64) async throws -> GetCategoryDetailResponse {
        guard let categoryDetail = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.getCategoryDetail(categoryId),
            responseType: GetCategoryDetailResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return categoryDetail
    }

    func postCategory(_ requestBody: PostCategoryRequest) async throws -> PostCategoryResponse {
        guard let categoryId = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.postCategory(requestBody),
            responseType: PostCategoryResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }

        return categoryId
    }

    func putCategory(id: Int64, _ query: PutCategoryRequest) async throws {
        try await NetworkService.shared.request(endpoint: CategoryEndpoint.putCategory(query, id: id))
    }

    func deleteCategory(_ categoryId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.deleteCategory(categoryId)
        )
    }
}
