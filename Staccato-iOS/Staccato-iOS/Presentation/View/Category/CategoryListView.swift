//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {

    @Environment(NavigationState.self) var navigationState
    @EnvironmentObject var mypageViewModel: MyPageViewModel
    @Bindable var bindableNavigationState: NavigationState
    
    @StateObject private var viewModel = CategoryViewModel()
    @State private var selectedCategory: CategoryModel?
    @State private var isDetailPresented: Bool = false
    @State private var isSortFilterMenuPresented: Bool = false
    @State private var isCreateCategoryModalPresented = false


    // MARK: - Initializer

    init(_ navigationState: NavigationState) {
        self.bindableNavigationState = navigationState
    }


    // MARK: - Body

    var body: some View {
        VStack {
            modalTop
            NavigationStack(path: $bindableNavigationState.path) {
                VStack(spacing: 0) {
                    titleHStack
                        .padding(.top, 22)
                        .padding(.bottom, 12)
                        .padding(.horizontal, 18)
                    categoryList
                }
                .background(Color.staccatoWhite)
                .frame(maxWidth: .infinity)
                .navigationDestination(for: HomeModalNavigationDestination.self) { destination in
                    switch destination {
                    case .staccatoDetail(let staccatoId): StaccatoDetailView(staccatoId)
                    case .categoryDetail(let categoryId): CategoryDetailView(categoryId, viewModel)
                    case .categoryAdd: CategoryEditorView(categoryViewModel: viewModel)
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

        .fullScreenCover(isPresented: $isCreateCategoryModalPresented) {
            CategoryEditorView(categoryViewModel: viewModel)
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
            Text("\(mypageViewModel.profile?.nickname ?? "나")의 추억들")
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
            isCreateCategoryModalPresented = true
        }
        .buttonStyle(.staccatoCapsule(
            icon: .folderFillBadgePlus,
            font: .body3,
            iconSpacing: 4)
        )
    }


    // MARK: - List

    var categoryList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.categories.enumerated()), id: \.element.id) { index, categoryInfo in
                    Button {
                        selectedCategory = categoryInfo
                        navigationState.navigate(to: .categoryDetail(categoryInfo.categoryId))
                    } label: {
                        CategoryListCell(categoryInfo)
                    }
                    
                    // 마지막 항목에는 Divider 추가하지 않음
                    if index < viewModel.categories.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }

}
