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
            getCategoryList()
        }
    }
    
    @Published var sortSelection: CategoryListSortType = .recentlyUpdated {
        didSet {
            getCategoryList()
        }
    }
    
    
    // MARK: - Networking
    
    func getCategoryList() {
        STService.shared.categoryServie.getCategoryList(
            GetCategoryListRequestQuery(
                filters: filterSelection.serverKey,
                sort: sortSelection.serverKey
            )
        ) { [weak self] response in
            guard let self = self else {
                print("🥑 self is nil")
                return
            }
            
            let categories = response.categories.map {
                CategoryModel(
                    id: $0.categoryId,
                    thumbNailURL: $0.categoryThumbnailUrl,
                    title: $0.categoryTitle,
                    startAt: $0.startAt,
                    endAt: $0.endAt
                )
            }
            
            DispatchQueue.main.async {
                self.categories = categories
            }
        }
    }
    
}
