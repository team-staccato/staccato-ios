//
//  CategoryDetailViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/12/25.
//

import Foundation

final class CategoryDetailViewModel: ObservableObject {

    private let categoryListViewModel: CategoryListViewModel
    
    @Published var categoryDetail: CategoryDetailModel?

    init(_ categoryListViewModel: CategoryListViewModel) {
        self.categoryListViewModel = categoryListViewModel
    }

}


// MARK: - Network

extension CategoryDetailViewModel {

    @MainActor
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
                try await categoryListViewModel.getCategoryList()
            } catch {
                print("⚠️ \(error.localizedDescription) - delete category")
            }
        }
    }

}
