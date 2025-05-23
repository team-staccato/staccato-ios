//
//  CategoryListSortView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/10/25.
//

import SwiftUI

struct CategoryListSortView: View { // TODO: 리팩토링: 컴포넌트화하기
    
    @Binding var sortSelection: CategoryListSortType
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            makeHeader(text: "정렬")

            makeDivider(height: 3)

            sortOptions
        }
        .background(Color(uiColor: .staccatoWhite))
        .frame(minWidth: 180)
        .padding(.vertical, 4)
    }
    
}


// MARK: - UI Components

extension CategoryListSortView {

    // MARK: - Header, Divider

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

    func makeDivider(height: CGFloat) -> some View {
        Rectangle()
            .frame(height: height)
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

}
