//
//  CategoryListViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI

@MainActor
final class CategoryListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var userName: String = "UserName" // TODO: API 연결
    
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
            self.categories = categories
        }
    }

}
