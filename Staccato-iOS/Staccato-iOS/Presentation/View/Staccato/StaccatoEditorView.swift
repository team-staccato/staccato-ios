//
//  StaccatoCreateView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/20/25.
//

import SwiftUI
import PhotosUI

import Lottie

struct StaccatoEditorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var viewModel: StaccatoEditorViewModel

    @FocusState var isTitleFocused: Bool

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    // NOTE: Create
    init(category: CategoryModel?) {
        self.viewModel = StaccatoEditorViewModel(selectedCategory: category)
    }

    // NOTE: Modify
    init(staccato: StaccatoDetailModel) {
        self.viewModel = StaccatoEditorViewModel(staccato: staccato)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                photoInputSection

                titleInputSection

                locationInputSection

                dateInputSection

                categorySelectSection

                Spacer()

                saveButton
            }
        }
        .onAppear {
            viewModel.getCategoryList()
        }

        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)

        .staccatoModalBar(
            title: "스타카토 기록하기",
            subtitle: "기억하고 싶은 순간을 남겨보세요!"
        )
        .sheet(isPresented: $viewModel.showPlaceSearchSheet) {
            GMSPlaceSearchViewController { place in
                self.viewModel.selectedPlace = place
            }
        }
        .alert(viewModel.errorTitle ?? "", isPresented: $viewModel.catchError) {
            Button("확인") {
                viewModel.catchError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }
    }
}

#Preview("Create") {
    StaccatoEditorView(category: nil)
        .environment(NavigationState())
}

#Preview("Modify") {
    StaccatoEditorView(
        staccato: StaccatoDetailModel(
            id: UUID(),
            staccatoId: 2,
            categoryId: 2,
            categoryTitle: "카테고리테스트",
            startAt: "2025-04-30T14:50:47.004Z",
            endAt: "2025-04-30T14:50:47.004Z",
            staccatoTitle: "타이틀",
            staccatoImageUrls: [
                "https://image.staccato.kr/web/share/happy.png",
                "https://image.staccato.kr/web/share/angry.png",
                "https://image.staccato.kr/web/share/poopoo.png"],
            visitedAt: "2025-04-30T14:50:47.004Z",
            feeling: "느낌",
            placeName: "스타복스",
            address: "대구시 북구 복현동",
            latitude: 30.0,
            longitude: 30.0
        )
    )
    .environment(NavigationState())
}

extension StaccatoEditorView {
    // MARK: - Photo
    private var photoInputSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text("사진")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Text("(\(viewModel.photos.count)/5)")
                    .foregroundStyle(.gray3)
                    .typography(.body4)

                Spacer()
            }
            .padding(.bottom, 16)

            photoInputGrid

        }
        .confirmationDialog("사진을 첨부해 보세요", isPresented: $viewModel.isPhotoInputPresented, titleVisibility: .visible, actions: {
            Button("카메라 열기") {
                viewModel.showCamera = true
            }

            Button("앨범에서 가져오기") {
                viewModel.isPhotoPickerPresented = true
            }
        })

        .photosPicker(isPresented: $viewModel.isPhotoPickerPresented, selection: $viewModel.photoItem)

        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraView(cameraMode: .multiple, imageList: self.$viewModel.photos)
                .background(.black)
        }

        .onChange(of: viewModel.photoItem) { _, newValue in
            Task {
                await viewModel.loadTransferable(from: newValue)
            }
        }

        .onChange(of: viewModel.photos) { oldValue, newValue in
            Task {
                if oldValue.count < newValue.count {
                    if let lastIndex = newValue.indices.last {
                        do {
                            try await viewModel.photos[lastIndex].uploadImage()
                        } catch {
                            viewModel.errorTitle = "이미지 업로드 실패"
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        }
    }

    private var photoInputGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            photoInputPlaceholder

            ForEach(viewModel.photos, id: \.id) { photo in
                photoPreview(photo: photo)
            }
        }
        .padding(0)
    }

    private var photoInputPlaceholder: some View {
        Button {
            viewModel.isPhotoInputPresented = true
        } label: {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    Image(.camera)
                        .frame(width: 28)

                    Text("사진을 첨부해 보세요")
                        .typography(.body3)
                }
                .foregroundStyle(.gray3)
                .frame(width: geometry.size.width - 5, height: geometry.size.width - 5)
                .background(.gray1, in: .rect(cornerRadius: 5))
            }
            .aspectRatio(1, contentMode: .fit)
        }

    }

    private func photoPreview(photo: UploadablePhoto) -> some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: photo.photo)
                    .resizable()
                    .scaledToFill()

                if photo.isUploading {
                    ZStack {
                        Color.staccatoWhite.opacity(0.8)
                        LottieView(animation: .named("UploadImage"))
                            .playing(loopMode: .loop)
                    }
                }

                if photo.isFailed {
                    ZStack {
                        Color.staccatoWhite.opacity(0.8)
                        Image(.photoBadgeExclamationmark)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 78)
                            .foregroundStyle(.black.opacity(0.2))
                    }
                }
            }
            .frame(width: geometry.size.width - 5, height: geometry.size.width - 5)
            .clipShape(.rect(cornerRadius: 5))
            .overlay(alignment: .topTrailing) {
                Button {
                    if let index = viewModel.photos.firstIndex(of: photo) {
                        withAnimation {
                            _ = viewModel.photos.remove(at: index)
                        }
                    }
                } label: {
                    Image(.minusCircle)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .gray3)
                        .background(Circle().fill(.staccatoWhite))
                        .frame(width: 25, height: 25)
                        .offset(x: 5, y: -5)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    // MARK: - Title
    private var titleInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "스타카토 제목")

            StaccatoTextField(
                text: $viewModel.title,
                isFocused: $isTitleFocused,
                placeholder: "어떤 순간이었나요? 제목을 입력해 주세요",
                maximumTextLength: 30
            )
            .focused($isTitleFocused)
        }
    }

    // MARK: - Location
    private var locationInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "장소")

            Button(viewModel.selectedPlace?.name ?? "장소명, 주소, 위치로 검색해보세요") {
                viewModel.showPlaceSearchSheet = true
            }
            .buttonStyle(.staticTextFieldButtonStyle(icon: .magnifyingGlass,
                                                     isActive: viewModel.selectedPlace != nil))
            .padding(.bottom, 10)

            Text("상세 주소")
                .typography(.title3)
                .foregroundStyle(.staccatoBlack)
                .padding(.bottom, 6)

            Text(viewModel.selectedPlace?.address ?? "상세주소는 여기에 표시됩니다.")
                .foregroundStyle(.gray3)
                .typography(.body1)
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.gray2)
                }
                .padding(.bottom, 10)

            Button("현재 위치의 주소 불러오기") {
                STLocationManager.shared.getCurrentPlaceInfo { place in
                    self.viewModel.selectedPlace = place
                }

            }
            .buttonStyle(.staccatoCapsule(icon: .location,
                                          font: .body4,
                                          verticalPadding: 12,
                                          fullWidth: true))
        }
    }

    // MARK: - Date
    private var dateInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "날짜 및 시간")

            Button(viewModel.selectedDate?.formattedAsFullDateWithHour ?? "방문 날짜를 선택해주세요") {
                viewModel.showDatePickerSheet = true
            }
            .buttonStyle(.staticTextFieldButtonStyle())

            .sheet(isPresented: $viewModel.showDatePickerSheet) {
                DatePickerView(selectedDate: $viewModel.selectedDate)
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }

    // MARK: - Category
    private var categorySelectSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "카테고리 선택")

            Menu(categoryMenuTitle) {
                ForEach(viewModel.categories, id: \.id) { category in
                    Button(category.title) {
                        self.viewModel.selectedCategory = category
                    }
                }
            }
            .buttonStyle(.staticTextFieldButtonStyle())
            .disabled(viewModel.categories.isEmpty)
        }
    }

    private var categoryMenuTitle: String {
        if viewModel.categories.isEmpty {
            return "생성된 카테고리가 없어요"
        } else {
            return viewModel.selectedCategory?.title ?? "카테고리를 선택해주세요"
        }
    }

    // MARK: - Save
    private var saveButton: some View {
        Button("저장") {
            Task {
                switch viewModel.editorMode {
                case .create:
                    await viewModel.createStaccato()
                    homeViewModel.fetchStaccatos()
                    dismiss()
                case .modify(let id):
                    await viewModel.modifyStaccato(staccatoId: id)
                    dismiss()
                }
            }
        }
        .buttonStyle(.staccatoFullWidth)
        .disabled(!viewModel.isReadyToSave)
    }

    // MARK: - Components
    private func sectionTitle(title: String) -> some View {
        return Group {
            Text(title)
                .foregroundStyle(.staccatoBlack)
            + Text(" *")
                .foregroundStyle(.accent)
        }
        .typography(.title2)
        .padding(.bottom, 8)
    }
}
