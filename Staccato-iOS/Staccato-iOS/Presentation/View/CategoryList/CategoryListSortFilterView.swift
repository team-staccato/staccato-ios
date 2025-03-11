//
//  CategoryListSortFilterView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/10/25.
//

import SwiftUI

struct CategoryListSortFilterView: View {
    @Binding var sortSelection: CategoryListSortType
    @Binding var filterSelection: CategoryListFilterType
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Sort Section
            makeHeader(text: "정렬")
            
            Divider()
            
            sortOptions
            
            thickDivider
            
            makeHeader(text: "필터")
            
            Divider()
            
            filterOptions
            
        }
        .background(Color(uiColor: .systemBackground))
    }
    
}


// MARK: - UI Components

extension CategoryListSortFilterView {
    
    // MARK: - Headers
    
    func makeHeader(text: String) -> some View {
        HStack {
            Text(text)
                .typography(.body4)
                .foregroundStyle(.gray4)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            Spacer()
        }
    }
    
    var thickDivider: some View {
        Rectangle()
            .frame(height: 8)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray1)
    }
    
    
    // MARK: - Options
    
    var sortOptions: some View {
        ForEach(Array(CategoryListSortType.allCases.enumerated()), id: \.element.id) { index, type in
            Button {
                sortSelection = type
                isPresented = false
            } label: {
                HStack {
                    Image(.checkmark)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .opacity(sortSelection == type ? 1 : 0)
                    
                    Text(type.text)
                        .typography(.body3)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if index < CategoryListSortType.allCases.count - 1 {
                Divider()
            }
            
        }
    }
    
    var filterOptions: some View {
        ForEach(Array(CategoryListFilterType.allCases.enumerated()), id: \.element.id) { index, type in
            Button {
                filterSelection = type
                isPresented = false
            } label: {
                HStack {
                    Image(.checkmark)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .opacity(filterSelection == type ? 1 : 0)
                    
                    Text(type.text)
                        .typography(.body3)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .hoverEffect()
            
            if index < CategoryListFilterType.allCases.count - 1 {
                Divider()
            }
        }
    }
    
}


// MARK: -  Preview
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
