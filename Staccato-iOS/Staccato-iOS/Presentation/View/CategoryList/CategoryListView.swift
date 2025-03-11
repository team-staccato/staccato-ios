//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {
    
    @StateObject private var viewModel = CategoryListViewModel()
    @State private var selectedCategory: CategoryModel?
    @State private var isDetailPresented: Bool = false
    @State private var isSortFilterMenuPresented: Bool = false
    
    var body: some View {
        VStack {
            modalTop
            
            NavigationStack {
                VStack(spacing: 0) {
                    titleHStack
                        .padding(.top, 22)
                        .padding(.bottom, 12)
                    categoryList
                }
                .background(Color.white)
                .padding(.horizontal, 18)
                .navigationDestination(isPresented: $isDetailPresented) {
                    if let category = selectedCategory {
                        // TODO: category 바인딩
                        CategoryDetailView()
                            .onDisappear {
                                isDetailPresented = false
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getCategoryList()
        }
    }
    
}


// MARK: - Preview

#Preview {
    CategoryListView()
}


// MARK: - UI Components

private extension CategoryListView {
    
    // MARK: - Modal top
    
    var modalTop: some View {
        Capsule()
            .frame(width: 40, height: 4)
            .padding(.top, 10)
            .foregroundStyle(.gray2)
    }
    
    
    // MARK: - TitleView
    
    var titleHStack: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.userName)의 추억들")
                .typography(.title1)
            
            HStack {
                categorySortFilterButton
                Spacer()
                categoryAddButton
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var categorySortFilterButton: some View {
        Button {
            isSortFilterMenuPresented.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(.sliderHorizontal3)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                Text("정렬/필터")
                    .typography(.body3)
                Image(.arrowtriangleDownFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 6, height: 6)
            }
            .foregroundStyle(.gray3)
        }
        .popover(
            isPresented: $isSortFilterMenuPresented,
            attachmentAnchor: .point(.bottom),
            arrowEdge: .top
        ) {
            CategoryListSortFilterView(
                sortSelection: $viewModel.sortSelection,
                filterSelection: $viewModel.filterSelection,
                isPresented: $isSortFilterMenuPresented)
            .presentationCompactAdaptation(.popover)
        }
    }
    
    var categoryAddButton: some View {
        Button("추가") {
            print("추가 버튼 클릭됨")
        }
        .buttonStyle(.staccatoCapsule(
            icon: .folderFillBadgePlus,
            font: .body3,
            spacing: 4)
        )
    }
    
    
    // MARK: - List
    
    var categoryList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.id) { categoryInfo in
                    Button {
                        selectedCategory = categoryInfo
                        isDetailPresented = true
                    } label: {
                        CategoryListCell(categoryInfo)
                    }
                }
            }
        }
    }
    
}
