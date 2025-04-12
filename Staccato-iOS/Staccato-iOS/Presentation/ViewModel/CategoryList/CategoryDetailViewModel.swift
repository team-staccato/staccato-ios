//
//  CategoryDetailViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/12/25.
//

import Foundation

final class CategoryDetailViewModel: ObservableObject {

    @Published var categoryDetail: CategoryDetailModel?

}


// MARK: - Network

extension CategoryDetailViewModel {

    @MainActor
    func getCategoryDetail(_ categoryId: Int64) {
        Task {
            do {
                let response = try await STService.shared.categoryServie.getCategoryDetail(categoryId)
                let categoryDetail = CategoryDetailModel(from: response)
                self.categoryDetail = categoryDetail
            } catch {
                print("⚠️ \(error.localizedDescription) - fetching category detail:")
            }
        }
    }

}
