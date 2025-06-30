//
//  SelectCategoryView.swift
//  Staccato-iOS
//
//  Created by 김영현 on 6/28/25.
//

import SwiftUI

struct SelectCategoryView: View {
    
    @Binding var selectedCategory: CategoryCandidateModel?
    @Binding var categories: [CategoryCandidateModel]
    
    @State private var category: CategoryCandidateModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("카테고리를 선택해 주세요")
                .typography(.title2)
                .padding(.leading, 24)
            
            Picker("Select Category", selection: $category) {
                ForEach(categories) { category in
                    Text(category.categoryTitle)
                        .tag(CategoryCandidateModel?.some(category))
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: category) { _, newValue in
                selectedCategory = newValue
            }
        }
        .onAppear {
            category = selectedCategory
        }
    }
}

#Preview {
    @Previewable @State var selectedCategory: CategoryCandidateModel?
    @Previewable @State var categories: [CategoryCandidateModel] = [
        CategoryCandidateModel(id: 1, categoryTitle: "카테카테1"),
        CategoryCandidateModel(id: 4, categoryTitle: "카테카테2"),
        CategoryCandidateModel(id: 5, categoryTitle: "카테카테3"),
        CategoryCandidateModel(id: 3, categoryTitle: "카테카테4"),
        CategoryCandidateModel(id: 2, categoryTitle: "카테고리길이가왜이렇게길어요이래도되는걸가요?")
    ]
    SelectCategoryView(selectedCategory: $selectedCategory, categories: $categories)
}
