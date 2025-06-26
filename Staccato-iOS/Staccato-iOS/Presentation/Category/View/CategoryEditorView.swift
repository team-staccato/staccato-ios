//
//  CategoryEditorView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI
import PhotosUI

struct CategoryEditorView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Environment(NavigationManager.self) private var navigationManager
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var viewModel: CategoryEditorViewModel
    @State private var showSettingAlert: Bool = false
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isDescriptionFocused: Bool

    init(
        categoryDetail: CategoryDetailModel? = nil,
        editorType: CategoryEditorViewModel.CategoryEditorType = .create,
        categoryViewModel: CategoryViewModel
    ) {
        self._viewModel = State(initialValue: CategoryEditorViewModel(
            categoryDetail: categoryDetail,
            editorType: editorType,
            categoryViewModel: categoryViewModel
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoSection
                    .padding(.bottom, 36)

                Group {
                    titleInputSection
                        .padding(.bottom, 24)

                    descriptionInputSection
                        .padding(.bottom, 24)

                    colorSettingSection
                        .padding(.bottom, 24)

                    periodSettingSection
                        .padding(.bottom, 24)

                    if viewModel.editorType == .create {
                        shareSettingSection
                            .padding(.bottom, 24)
                    }
                }
                .padding(.horizontal, 4)

                Spacer()

                Button("저장") {
                    Task {
                        switch viewModel.editorType {
                        case .create:
                            await viewModel.saveCategory(.create) { categoryId in
                                guard let categoryId else { return }
                                
                                navigationManager.navigate(to: .categoryDetail(categoryId))
                            }
                        case .modify:
                            await viewModel.saveCategory(.modify)
                            
                            // 마커 업데이트
                            if let staccatoIds = viewModel.categoryDetail?.staccatos.map({ $0.staccatoId }) {
                                homeViewModel.updateMarkerIcons(
                                    for: staccatoIds,
                                    to: viewModel.categoryColor
                                )
                            }
                        }
                    }
                }
                .buttonStyle(.staccatoFullWidth)
                .disabled(viewModel.isSubmitButtonDisabled || viewModel.isSaving)
            }
            .animation(.easeIn(duration: 0.15), value: viewModel.isPeriodSettingActive)
        }
        .dismissKeyboardOnGesture()
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)

        .staccatoModalBar(
            title:
                self.viewModel.editorType == . create ? "카테고리 만들기" : "카테고리 수정하기",
            subtitle:
                self.viewModel.editorType == . create ? "스타카토를 담을 카테고리를 만들어 보세요!" : "스타카토를 담을 카테고리를 수정해 보세요!"
        )

        .sheet(isPresented: $viewModel.isPeriodSheetPresented) {
            StaccatoDatePicker(isDatePickerPresented: $viewModel.isPeriodSheetPresented, selectedStartDate: $viewModel.selectedStartDate, selectedEndDate: $viewModel.selectedEndDate)
        }

        .sheet(isPresented: $viewModel.isColorPalettePresented) {
            colorPaletteModal
                .presentationDetents([.height(410)])
        }

        .alert(viewModel.errorTitle ?? "", isPresented: $viewModel.catchError) {
            Button("확인") {
                viewModel.catchError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }

        .onChange(of: viewModel.uploadSuccess) { _, uploadSuccess in
            if uploadSuccess {
                dismiss()
            }
        }
    }
}

// MARK: - Section

extension CategoryEditorView {
    
    // MARK: Photo Section
    private var photoSection: some View {
        Button {
            viewModel.isPhotoInputPresented = true
        } label: {
            if let photo = viewModel.selectedPhoto {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            } else {
                photoPlaceholder
            }
        }
        .frame(height: 200)
        .clipShape(.rect(cornerRadius: 8))
        .contentShape(.rect(cornerRadius: 8))
        .padding(.top, 12)
        .onChange(of: viewModel.photoItem) { _, newValue in
            Task {
                await viewModel.loadTransferable(from: newValue)
                try await viewModel.uploadImage()
            }
        }

        .confirmationDialog("사진을 첨부해 보세요", isPresented: $viewModel.isPhotoInputPresented, titleVisibility: .visible, actions: {
            Button("카메라 열기") {
                CameraView.checkCameraPermission { granted in
                    if granted {
                        viewModel.showCamera = granted
                    } else {
                        showSettingAlert = true
                    }
                }
            }

            Button("앨범에서 가져오기") {
                viewModel.isPhotoPickerPresented = true
            }
        })

        .photosPicker(isPresented: $viewModel.isPhotoPickerPresented, selection: $viewModel.photoItem, matching: .images)

        .fullScreenCover(isPresented: $viewModel.showCamera) {
            Task {
                try await viewModel.uploadImage()
            }
        } content: {
            CameraView(selectedImage: $viewModel.selectedPhoto)
                .background(.staccatoBlack)
        }
        
        .alert(isPresented: $showSettingAlert) {
            Alert(
                title: Text("현재 카메라 사용에 대한 접근 권한이 없습니다."),
                message: Text("설정에서 카메라 접근을 활성화 해주세요."),
                primaryButton: .default(Text("설정으로 이동"), action: {
                    if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingURL)
                    }
                }),
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }

    private var photoPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.gray1)
            .overlay {
                VStack(spacing: 0) {
                    Image(.camera)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray4)
                        .frame(width: 37)
                        .padding(.bottom, 10)

                    Text("사진을 첨부해주세요")
                        .typography(.body4)
                        .foregroundStyle(.gray4)
                }
            }
    }

    // MARK: Title Input Section
    private var titleInputSection: some View {
        VStack(alignment: .leading) {
            Group {
                Text("카테고리 제목 ")
                    .foregroundStyle(.staccatoBlack)
                + Text("*")
                    .foregroundStyle(.staccatoBlue)
            }
            .typography(.title2)
            .padding(.bottom, 8)

            StaccatoTextField(
                text: $viewModel.categoryTitle,
                isFocused: $isTitleFocused,
                placeholder: "카테고리 제목을 입력해주세요(최대 30자)",
                maximumTextLength: 30
            )
            .focused($isTitleFocused)
        }
    }

    // MARK: Description Input Section
    private var descriptionInputSection: some View {
        VStack(alignment: .leading) {
            Text("카테고리 소개")
                .foregroundStyle(.staccatoBlack)
                .typography(.title2)

            TextEditor(text: $viewModel.categoryDescription)
                .staccatoTextEditorStyle(
                    placeholder: "카테고리 소개를 입력해주세요(최대 500자)",
                    text: $viewModel.categoryDescription,
                    maximumTextLength: 500,
                    isFocused: $isDescriptionFocused
                )
                .focused($isDescriptionFocused)
        }
    }

    // MARK: Color Setting Section
    private var colorSettingSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text("카테고리 색상 선택")
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
                
                Text("지도 위에서 보여질 마커의 색을 선택해주세요.")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
            }

            Spacer()

            Button {
                viewModel.isColorPalettePresented = true
            } label: {
                Image(uiImage: viewModel.categoryColor.markerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26,height: 32)
            }
            .padding(.trailing, 10)
            .padding(.top, 3)
        }
    }
    
    private var colorPaletteModal: some View {
        let spacing = (ScreenUtils.width - 48 - 28 * 6) / 5
        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: 6)
        viewModel.categoryColorTemp = viewModel.categoryColor

        return VStack(alignment: .leading) {
            Text("색상을 선택해 주세요")
                .typography(.title2)
                .foregroundStyle(.staccatoBlack)
                .padding(.bottom, 24)

            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(CategoryColorType.allCases, id: \.self) { colorType in
                    ZStack {
                        Circle()
                            .fill(colorType.color)
                            .frame(width: 28, height: 28)
                            .onTapGesture {
                                viewModel.categoryColorTemp = colorType
                            }
                        if viewModel.categoryColorTemp == colorType {
                            Image(StaccatoIcon.chevronDown)
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundColor(.staccatoWhite)
                                .padding(.top, 1)
                        }
                    }
                }
            }

            Spacer()

            Button("확인") {
                viewModel.categoryColor = viewModel.categoryColorTemp
                viewModel.isColorPalettePresented = false
            }
            .buttonStyle(.staccatoFullWidth)
        }
        .padding(24)
    }

    // MARK: Period Setting Section
    private var periodSettingSection: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("기간 설정")
                        .foregroundStyle(.staccatoBlack)
                        .typography(.title2)
                    Text("여행처럼 시작일과 종료일을 설정할 수 있어요.")
                        .typography(.body4)
                        .foregroundStyle(.gray3)
                }

                Spacer()

                Toggle("", isOn: $viewModel.isPeriodSettingActive)
                    .toggleStyle(StaccatoToggleStyle())
            }

            if viewModel.isPeriodSettingActive {
                Button {
                    viewModel.isPeriodSheetPresented = true
                } label: {
                    Text(viewModel.categoryPeriod ?? "카테고리 기간을 선택해주세요")
                        .foregroundStyle(viewModel.categoryPeriod == nil ? .gray3 : .staccatoBlack)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray1)
                        }
                }
            }
        }
    }

    // MARK: Share Setting Section
    private var shareSettingSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("카테고리 공유")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)
                    .padding(.bottom, 5)

                Text("친구들을 초대해 함께 카테고리를 채워보세요.")
                    .typography(.body4)
                    .foregroundStyle(.gray3)
                    .padding(.bottom, 3)

                HStack(spacing: 3) {
                    Image(StaccatoIcon.infoCircle)
                        .resizable()
                        .frame(width: 9, height: 9)
                    Text("한 번 설정하면 변경할 수 없어요")
                        .typography(.body5)
                }
                .foregroundStyle(.staccatoBlue70)
            }

            Spacer()

            Toggle("", isOn: $viewModel.isShareSettingActive)
                .toggleStyle(StaccatoToggleStyle())
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NavigationLink("이동") {
            CategoryEditorView(categoryViewModel: CategoryViewModel())
        }
    }
}

#Preview("수정") {
    CategoryEditorView(
        categoryDetail: CategoryDetailModel(
            categoryId: 1,
            categoryThumbnailUrl: "https://image.staccato.kr/web/share/happy.png",
            categoryTitle: "테스트카테고리",
            description: "이건 설명",
            categoryColor: .gray,
            startAt: "2024-01-01",
            endAt: "2024-01-30",
            isShared: true,
            members: [],
            staccatos: []
        ),
        editorType: .modify,
        categoryViewModel: CategoryViewModel()
    )
    .environment(NavigationManager())
}
