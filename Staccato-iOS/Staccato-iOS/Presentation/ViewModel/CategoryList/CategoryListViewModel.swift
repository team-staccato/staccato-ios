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
    
    var categories: [CategoryModel] = [
        CategoryModel(
            id: 1,
            thumbNail: Image(uiImage: .staccatoCharacter),
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        ),
        CategoryModel(
            id: 2,
            thumbNail: nil,
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        ),
        CategoryModel(
            id: 3,
            thumbNail: Image(uiImage: .staccatoCharacter),
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        )
    ]
    
}
