//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {
    
    @StateObject var viewModel = CategoryListViewModel()
    
    var body: some View {
            VStack {
                handle
                    .padding(.top, 10)
                    .padding(.bottom, 22)
                
                titleHStack
                
                categoryList
            }
            .background(Color.white)
            .padding(.horizontal, 18)
    }
    
}

// MARK: - Preview

#Preview {
    CategoryListView()
}


// MARK: - UI Components

private extension CategoryListView {
    
    // MARK: - Handle
    
    var handle: some View {
        Image(uiImage: .iconHandle)
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
        capsuleButton(icon: .iconFolder, text: "추가") {
            print("추가 버튼 클릭됨")
        }
    }
    
    var categorySortButton: some View {
        capsuleButton(icon: .iconSort, text: "정렬") {
            print("정렬 버튼 클릭됨")
        }
    }
    
    
    // MARK: - List
    
    // TODO: padding 영역까지 선택되는 문제 해결
    var categoryList: some View {
        List(viewModel.categories) { categoryInfo in
            ZStack {
                NavigationLink(destination: ContentView()) {
                    EmptyView()
                }
                    .opacity(0)
                
                CategoryListCell(categoryInfo)
            }
            .padding(.vertical, 6)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
}


// MARK: - UI Component Generator

private extension CategoryListView {
    
    func capsuleButton(
        icon: UIImage,
        text: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(uiImage: icon)
                    .frame(width: 14, height: 14)
                
                Text(text)
                    .typography(.body4)
                    .foregroundStyle(.gray3)
                    .frame(minWidth: 23)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
        }
        .buttonStyle(.plain)
        .overlay(
            Capsule()
                .stroke(.gray3, lineWidth: 0.5)
        )
    }
    
}
