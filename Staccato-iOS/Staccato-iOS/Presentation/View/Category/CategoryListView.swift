//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {
    
    @StateObject private var viewModel = CategoryListViewModel()
    @ObservedObject private var homeViewModel: HomeViewModel

    @State private var selectedCategory: CategoryModel?
    @State private var isDetailPresented: Bool = false
    @State private var isSortFilterMenuPresented: Bool = false
    
    
    // MARK: - Initializer
    
    init(_ homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            modalTop
            
            NavigationStack(path: $homeViewModel.modalNavigationState.path) {
                VStack(spacing: 0) {
                    titleHStack
                        .padding(.top, 22)
                        .padding(.bottom, 12)
                    categoryList
                }
                .background(Color.white)
                .padding(.horizontal, 18)
                .navigationDestination(for: HomeModalNavigationDestination.self) { destination in
                    switch destination {
                    case .staccatoDetail(let staccatoId): StaccatoDetailView(staccatoId)
                    case .staccatoAdd: StaccatoCreateView()
                    case .categoryDetail(let categoryId): CategoryDetailView(categoryId, homeViewModel: homeViewModel, categoryListViewModel: viewModel)
                    case .categoryAdd: CategoryEditorView()
                    }
                }
            }
        }
        .onAppear {
            do {
                try viewModel.getCategoryList()
            } catch {
                // 여기서 에러 메세지 띄우는 동작 등 구현
                print(error.localizedDescription)
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
            homeViewModel.modalNavigationState.navigate(to: .categoryAdd)
            // TODO: modal fullScreen mode
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
                        homeViewModel.modalNavigationState.navigate(to: .categoryDetail(categoryInfo.categoryId))
                    } label: {
                        CategoryListCell(categoryInfo)
                    }
                }
            }
        }
    }
    
}
