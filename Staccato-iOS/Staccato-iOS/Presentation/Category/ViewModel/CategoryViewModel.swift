//
//  CategoryViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI

@MainActor
final class CategoryViewModel: ObservableObject {
    
    enum State {
        case host
        case member
    }

    // MARK: - Properties

    @Published var categories: [CategoryModel] = []

    @Published var filterSelection: CategoryListFilterType = .all
    @Published var sortSelection: CategoryListSortType = .recentlyUpdated

    @Published var categoryDetail: CategoryDetailModel?


    // MARK: - Networking

    func getCategoryList() async throws {
        let categoryList = try await STService.shared.categoryService.getCategoryList(
            GetCategoryListRequestQuery(
                filters: filterSelection.serverKey,
                sort: sortSelection.serverKey
            )
        )
        
        let categories = categoryList.categories.map { CategoryModel(from: $0) }
        withAnimation {
            self.categories = categories
        }
    }

    func getCategoryDetail(_ categoryId: Int64) {
        Task {
            do {
                let response = try await STService.shared.categoryService.getCategoryDetail(categoryId)
                let categoryDetail = CategoryDetailModel(from: response)
                self.categoryDetail = categoryDetail
            } catch {
                print("⚠️ \(error.localizedDescription) - fetching category detail")
            }
        }
    }

    func deleteCategory(_ state: State) async -> Bool {
        guard let categoryDetail else {
            print("⚠️ \(StaccatoError.optionalBindingFailed) - delete category")
            return false
        }

        do {
            switch state {
            case .host:
                try await STService.shared.categoryService.deleteCategory(categoryDetail.categoryId)
            case .member:
                try await STService.shared.categoryService.deleteCategoryFromMe(categoryDetail.categoryId)
            }
            return true
        } catch {
            print("⚠️ \(error.localizedDescription) - delete category")
            return false
        }
    }
}
