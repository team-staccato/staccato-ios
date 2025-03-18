//
//  CategoryListViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI

final class CategoryListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var userName: String = "UserName" // TODO: API 연결
    
    @Published var categories: [CategoryModel] = []
    
    @Published var filterSelection: CategoryListFilterType = .all {
        didSet {
            do {
                try getCategoryList()
            } catch {
                // 여기서 에러 처리
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var sortSelection: CategoryListSortType = .recentlyUpdated {
        didSet {
            do {
                try getCategoryList()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Networking
    
    func getCategoryList() throws {
        Task {
            let categoryList = try await STService.shared.categoryServie.getCategoryList(
                GetCategoryListRequestQuery(
                    filters: filterSelection.serverKey,
                    sort: sortSelection.serverKey
                )
            )
            
            let categories = categoryList.categories.map {
                CategoryModel(
                    id: $0.categoryId,
                    thumbNailURL: $0.categoryThumbnailUrl,
                    title: $0.categoryTitle,
                    startAt: $0.startAt,
                    endAt: $0.endAt
                )
            }
            
            self.categories = categories
        }
    }
    
}
