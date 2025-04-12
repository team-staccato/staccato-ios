//
//  CategoryService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

protocol CategoryServiceProtocol {

    func getCategoryList(_ query: GetCategoryListRequestQuery) async throws -> GetCategoryListResponse

    func getCategoryDetail(_ categoryId: Int64) async throws -> GetCategoryDetailResponse

    func createCategory(_ query: CreateCategoryRequestQuery) async throws -> CreateCategoryResponse

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

    func getCategoryDetail(_ categoryId: Int64) async throws -> GetCategoryDetailResponse {
        guard let categoryDetail = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.getCategoryDetail(categoryId),
            responseType: GetCategoryDetailResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return categoryDetail
    }

    @discardableResult
    func createCategory(_ query: CreateCategoryRequestQuery) async throws -> CreateCategoryResponse {
        guard let categoryId = try await NetworkService.shared.request(
            endpoint: CategoryEndpoint.createCategory(query),
            responseType: CreateCategoryResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }

        return categoryId
    }

}
