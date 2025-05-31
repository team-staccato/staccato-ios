//
//  CategoryViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI

@MainActor
final class CategoryViewModel: ObservableObject {

    // MARK: - Properties

    @Published var categories: [CategoryModel] = []

    @Published var filterSelection: CategoryListFilterType = .all {
        didSet {
            do {
                try getCategoryList()
            } catch {
                print("❌ error: \(error.localizedDescription)")
            }
        }
    }

    @Published var sortSelection: CategoryListSortType = .recentlyUpdated {
        didSet {
            do {
                try getCategoryList()
            } catch {
                print("❌ error: \(error.localizedDescription)")
            }
        }
    }

    @Published var categoryDetail: CategoryDetailModel?


    // MARK: - Networking

    func getCategoryList() throws {
        Task {
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

    func deleteCategory() {
        guard let categoryDetail else {
            print("⚠️ \(StaccatoError.optionalBindingFailed) - delete category")
            return
        }
        Task {
            do {
                try await STService.shared.categoryService.deleteCategory(categoryDetail.categoryId)
                try getCategoryList()
            } catch {
                print("⚠️ \(error.localizedDescription) - delete category")
            }
        }
    }

}
