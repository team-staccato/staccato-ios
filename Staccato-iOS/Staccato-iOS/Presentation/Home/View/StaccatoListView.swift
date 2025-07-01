//
//  StaccatoListView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 6/29/25.
//

import SwiftUI

struct StaccatoListView: View {

    @EnvironmentObject private var viewModel: HomeViewModel
    @Environment(NavigationManager.self) var navigationManager

    let staccatos: [StaccatoCoordinateModel]

    init(staccatos: [StaccatoCoordinateModel]) {
        self.staccatos = staccatos
    }

    var body: some View {
        ZStack {
            Color(.staccatoBlack).opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { viewModel.isStaccatoListPresented = false }

            staccatoListPopup
        }
        .background(TransparentViewRepresentable())
    }

}


// MARK: - UI components

private extension StaccatoListView {

    var staccatoListPopup: some View {
        VStack(spacing: 33) {
            headerView
                .padding(.top, 19)
            staccatoList
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(.staccatoWhite))
        .padding(.horizontal, 16)
        .frame(maxHeight: 540)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }

    var headerView: some View {
        ZStack {
            HStack {
                Button {
                    viewModel.isStaccatoListPresented = false
                } label: {
                    Image(StaccatoIcon.xmark)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.gray3)
                        .padding(.leading, 15)
                }
                Spacer()
            }

            HStack {
                Spacer()
                Text("스타카토 목록")
                    .typography(.title2)
                    .foregroundStyle(.gray5)
                Spacer()
            }
        }
    }

    var staccatoList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(staccatos.enumerated()), id: \.element.id) { index, staccatoInfo in
                    Button {
                        navigationManager.navigate(to: .staccatoDetail(staccatoInfo.staccatoId))
                        viewModel.isStaccatoListPresented = false
                    } label: {
                        StaccatoListCell(staccatoInfo)
                    }
                    
                    // 마지막 항목에는 Divider 추가하지 않음
                    if index < staccatos.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }

}

#Preview {
    StaccatoListView(staccatos: [StaccatoCoordinateModel(id: 1, staccatoId: 1, staccatoColor: .RedLight, latitude: 32.2, longitude: 137.5, title: "hello", visitedAt: "2025-06-10T17:30:04"),StaccatoCoordinateModel(id: 2, staccatoId: 2, staccatoColor: .RedLight, latitude: 32.2, longitude: 137.5, title: "hello", visitedAt: "2025-06-10T17:30:04"),StaccatoCoordinateModel(id: 3, staccatoId: 3, staccatoColor: .RedLight, latitude: 32.2, longitude: 137.5, title: "hello", visitedAt: "2025-06-10T17:30:04")])
        .environment(NavigationManager())
}
