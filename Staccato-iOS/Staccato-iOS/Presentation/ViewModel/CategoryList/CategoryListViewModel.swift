//
//  CategoryListViewModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI
import Observation

@Observable final class CategoryListViewModel {
    
    // MARK: - Properties
    
    var userName: String = "UserName"
    
    @Published var categories: [CategoryModel] = []
    
    
    // MARK: - Networking
    
    func getCategoryList(filters: CategoryFilterType?, sort: CategorySortType?) {
        STService.shared.categoryServie.getCategoryList(
            GetCategoryListRequestQuery(
                filters: filters?.serverKey,
                sort: sort?.serverKey
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
