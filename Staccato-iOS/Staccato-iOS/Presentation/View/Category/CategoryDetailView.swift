//
//  CategoryDetailView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI
import Kingfisher

struct CategoryDetailView: View {
    
    @Environment(NavigationState.self) var navigationState
    @Environment(StaccatoAlertManager.self) var alertManager
    @EnvironmentObject var detentManager: BottomSheetDetentManager
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    private let categoryId: Int64
    @ObservedObject var viewModel: CategoryViewModel
    
    @State private var isStaccatoCreateViewPresented = false
    @State private var isCategoryModifyModalPresented = false
    @State private var isinvitationSheetPresented = false
    
    private let horizontalInset: CGFloat = 16
    
    init(_ categoryId: Int64, _ categoryViewModel: CategoryViewModel) {
        self.categoryId = categoryId
        self.viewModel = categoryViewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    
                    if viewModel.categoryDetail?.description != nil && viewModel.categoryDetail?.description != "" {
                        descriptionSection
                    }
                    
                    if viewModel.categoryDetail?.isShared ?? false {
                        sharedMemberSection
                    }
                    
                    staccatoCollectionSection
                }
                .frame(width: ScreenUtils.width)
            }
            .background(.staccatoWhite)
            .ignoresSafeArea(.container, edges: .bottom)
            
            .staccatoNavigationBar {
                if viewModel.categoryDetail?.members[0].id == AuthTokenManager.shared.getUserId() {
                    Button("수정") {
                        isCategoryModifyModalPresented = true
                    }
                    
                    Button("삭제") {
                        // TODO: - 삭제 버튼 시 alert가 sheet 뒤로 뜨는 이슈
                        presentDeleteAlert()
                    }
                }
            }
            
            .onAppear {
                detentManager.updateDetent(geometry.size.height)
                viewModel.getCategoryDetail(categoryId)
            }
            
            .onChange(of: geometry.size.height) { _, height in
                detentManager.updateDetent(height)
            }
            
            .onChange(of: homeViewModel.staccatos) {
                viewModel.getCategoryDetail(categoryId)
            }
            
            .fullScreenCover(isPresented: $isStaccatoCreateViewPresented) {
                StaccatoEditorView(category: viewModel.categoryDetail?.toCategoryCandidateModel())
            }
            
            .fullScreenCover(isPresented: $isCategoryModifyModalPresented) {
                CategoryEditorView(
                    categoryDetail: self.viewModel.categoryDetail,
                    editorType: .modify,
                    categoryViewModel: viewModel
                )
            }
        }
    }
}


// MARK: - UI Components

private extension CategoryDetailView {
    
    var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: viewModel.categoryDetail?.categoryThumbnailUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: ScreenUtils.width, height: ScreenUtils.width * 0.67, alignment: .center)
                .clipped()
            
            Rectangle()
                .foregroundStyle(linearGradient)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.categoryDetail?.categoryTitle ?? "")
                    .typography(.title1)
                    .foregroundStyle(.staccatoWhite)
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                
                if let startAt = viewModel.categoryDetail?.startAt,
                   let endAt = viewModel.categoryDetail?.endAt {
                    Text("\(startAt) ~ \(endAt)")
                        .typography(.body4)
                        .foregroundStyle(.staccatoWhite)
                }
            }
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, 14)
        }
    }
    
    var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.staccatoBlack.opacity(0.2), location: 0.0),
                .init(color: Color.staccatoBlack.opacity(0.6), location: 0.67),
                .init(color: Color.staccatoBlack.opacity(0.85), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    @ViewBuilder
    var descriptionSection: some View {
        if let description = viewModel.categoryDetail?.description {
            VStack(spacing: 16) {
                Text(description)
                    .typography(.body2)
                    .foregroundStyle(.staccatoBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                Divider()
            }
        }
    }
    
    var sharedMemberSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("함께하는 사람들")
                .typography(.title2)
                .foregroundStyle(.staccatoBlack)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    if viewModel.categoryDetail?.members[0].id == AuthTokenManager.shared.getUserId() {
                        invitationButton
                    }
                    ForEach(viewModel.categoryDetail?.members ?? []) { member in
                        CategoryDetailMemberCell(member: member)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 2)
            }
            
            Divider()
        }
        .padding(.horizontal, horizontalInset)
    }
    
    var invitationButton: some View {
        Button {
            isinvitationSheetPresented = true
        } label: {
            Circle()
                .fill(Color.white)
                .stroke(Color.gray2, lineWidth: 1)
                .frame(width: 45, height: 45)
                .overlay {
                    Image(.plus)
                        .frame(width: 13, height: 13)
                        .foregroundStyle(Color.staccatoBlack)
                }
        }
        .fullScreenCover(isPresented: $isinvitationSheetPresented) {
            // TODO: - Background 애니메이션 수정 필요
            if let categoryId = viewModel.categoryDetail?.categoryId {
                InvitationMemberView(categoryId: categoryId)
                    .presentationBackground(.black.opacity(0.2))
            }
        }
    }
    
    var staccatoCollectionSection: some View {
        let staccatos = viewModel.categoryDetail?.staccatos ?? []
        let columnWidth: CGFloat = (ScreenUtils.width - horizontalInset * 2 - 8) / 2
        let columns = [
            GridItem(.fixed(columnWidth), spacing: 8),
            GridItem(.fixed(columnWidth))
        ]
        
        return VStack(spacing: 19) {
            HStack {
                Text("스타카토")
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
                    .padding(.leading, 4)
                
                Spacer()
                
                Button("기록하기") {
                    isStaccatoCreateViewPresented = true
                }
                .buttonStyle(.staccatoCapsule(icon: .pencilLine))
            }
            
            if staccatos.isEmpty {
                emptyCollection
                    .padding(.top, 40)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(staccatos) { staccato in
                        StaccatoCollectionCell(staccato, width: columnWidth)
                            .onTapGesture {
                                navigationState.navigate(to: .staccatoDetail(staccato.staccatoId))
                            }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalInset)
    }
    
    var emptyCollection: some View {
        VStack(spacing: 10) {
            Image(.staccatoCharacter)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)
            
            Text("스타카토를 아직 찍지 않으셨군요!\n스타카토를 찍어볼까요?")
                .typography(.body2)
                .foregroundStyle(.staccatoBlack)
                .multilineTextAlignment(.center)
        }
    }
}


// MARK: - Helper

private extension CategoryDetailView {
    
    func presentDeleteAlert() {
        withAnimation {
            alertManager.show(
                .confirmCancelAlert(
                    title: "삭제하시겠습니까?",
                    message: "삭제를 누르면 복구할 수 없습니다."
                ) {
                    Task {
                        let success = await viewModel.deleteCategory()
                        if success {
                            navigationState.dismiss()
                            
                            if let staccatoIds = viewModel.categoryDetail?.staccatos.map(\.staccatoId) {
                                homeViewModel.removeStaccatos(with: Set(staccatoIds))
                            }
                        }
                    }
                }
            )
        }
    }
}
