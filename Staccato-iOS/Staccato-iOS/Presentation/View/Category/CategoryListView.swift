//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {

    @Environment(NavigationState.self) var navigationState
    @Environment(HomeModalManager.self) private var homeModalManager
    @EnvironmentObject var mypageViewModel: MyPageViewModel
    @Bindable var bindableNavigationState: NavigationState
    
    @StateObject private var viewModel = CategoryViewModel()
    @State private var selectedCategory: CategoryModel?
    @State private var isDetailPresented: Bool = false
    @State private var isSortMenuPresented: Bool = false
    @State private var onSpotFilter: Bool = false
    @State private var isCreateCategoryModalPresented = false


    // MARK: - Initializer

    init(_ navigationState: NavigationState) {
        self.bindableNavigationState = navigationState
    }


    // MARK: - Body

    var body: some View {
        NavigationStack(path: $bindableNavigationState.path) {
            VStack(spacing: 0) {
                titleSection
                    .padding(.top, 8)
                    .padding(.horizontal, 18)

                if homeModalManager.modalSize != .small {
                    filterSection
                        .padding(.top, 20)
                        .padding(.horizontal, 18)

                    categoryList
                        .padding(.top, 10)
                }

                Spacer()
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

        .onAppear {
            fetchCategoryList()
        }

        .onChange(of: viewModel.filterSelection) {
            fetchCategoryList()
        }

        .onChange(of: viewModel.sortSelection) {
            fetchCategoryList()
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

    var titleSection: some View {
        HStack {
            Text("\(mypageViewModel.profile?.nickname ?? "나")의 추억들")
                .typography(.title1)
            Spacer()
            categoryAddButton
        }
        .frame(maxWidth: .infinity)
    }

    var filterSection: some View {
        HStack {
            categorySortButton
            Spacer()
            categoryFilterButton
        }
        .frame(maxWidth: .infinity)
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

    var categorySortButton: some View {
        Button {
            isSortMenuPresented.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(.sliderHorizontal3)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                Text(viewModel.sortSelection.text)
                    .typography(.body3)
                Image(.arrowtriangleDownFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 6, height: 6)
            }
            .foregroundStyle(.gray3)
        }
        .popover(
            isPresented: $isSortMenuPresented,
            attachmentAnchor: .point(.bottom),
            arrowEdge: .top
        ) {
            CategoryListSortView(
                sortSelection: $viewModel.sortSelection,
                isPresented: $isSortMenuPresented)
            .presentationCompactAdaptation(.popover)
        }
    }

    var categoryFilterButton: some View {
        Button {
            onSpotFilter.toggle()
            viewModel.filterSelection = onSpotFilter ? .term : .all
        } label: {
            HStack {
                Image(.line3HorizontalDecrease)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                Text("기간 있는 카테고리만")
                    .typography(.body4)
            }
            .foregroundStyle(onSpotFilter ? .accent : .gray3)
        }
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


// MARK: - Helper

private extension CategoryListView {

    func fetchCategoryList() {
        Task {
            do {
                try await viewModel.getCategoryList()
            } catch {
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }

}
