//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {
    
    // MARK: - Properties
    
    let viewModel = CategoryListViewModel()
    
    @State private var navigationState: CategoryNavigationState
    
    @State private var selectedCategory: CategoryModel?
    
    
    // MARK: - Initializer
    
    init(_ navigationState: CategoryNavigationState) {
        self.navigationState = navigationState
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            modalTop
            
            NavigationStack(path: $navigationState.path) {
                VStack {
                    titleHStack
                        .padding(.top, 23)
                    categoryList
                }
                .background(Color.white)
                .padding(.horizontal, 18)
                .navigationDestination(for: CategoryNavigationDestination.self) { destination in
                    switch destination {
                    case .staccatoDetail: StaccatoDetailView()
                    case .staccatoAdd: StaccatoCreateView()
                    case .categoryDetail: CategoryDetailView()
                    case .categoryAdd: CategoryEditorView()
                    }
                }
            }
        }
    }
    
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
        HStack {
            Text("\(viewModel.userName)의 추억들")
                .typography(.title1)
            Spacer()
            
            HStack(spacing: 5) {
                categoryAddButton
                categorySortButton
            }
        }
    }
    
    var categoryAddButton: some View {
        Button("추가") {
            navigationState.navigate(to: .categoryAdd)
            // TODO: modal fullScreen mode
        }
        .buttonStyle(.staccatoCapsule(
            icon: .folderFill,
            font: .body4,
            spacing: 4)
        )
    }
    
    var categorySortButton: some View {
        Button("정렬") {
            print("정렬 버튼 클릭됨")
        }
        .buttonStyle(.staccatoCapsule(
            icon: .sliderHorizontal3,
            font: .body4,
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
                        navigationState.navigate(to: .categoryDetail)
                    } label: {
                        CategoryListCell(categoryInfo)
                    }
                }
            }
        }
    }
    
}
