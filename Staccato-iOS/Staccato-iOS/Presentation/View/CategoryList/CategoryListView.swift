//
//  CategoryListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryListView: View {
    @State var userName: String = "UserName"
    @State var categoryList: [CategoryModel] = []
    
    var body: some View {
        titleHStack
    }
    
    
}

#Preview {
    CategoryListView()
}


// MARK: - UI Components

extension CategoryListView {
    
    private var titleHStack: some View {
        HStack {
            Text("\(userName)의 추억들")
                .typography(.title1)
            Spacer()
//            Button(label: {
//                Image()
//            })
        }
    }
    
}
