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
    @Environment(\.openURL) var openURL
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var viewModel: StaccatoEditorViewModel
    @State private var showLocationAlert: Bool = false
    @State private var isPhotoFull: Bool = false
    @State private var showSettingAlert: Bool = false
    @State private var isPhotoFocused: Bool = false

    @FocusState var isTitleFocused: Bool
    
    let columns = [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)]

    // NOTE: Create
    init(category: CategoryCandidateModel?) {
        self.viewModel = StaccatoEditorViewModel(selectedCategory: category)
    }

    // NOTE: Modify
    init(staccato: StaccatoDetailModel) {
        self.viewModel = StaccatoEditorViewModel(staccato: staccato)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                photoInputSection
                    .padding(.bottom, 40)

                titleInputSection
                    .padding(.bottom, 40)

                locationInputSection
                    .padding(.bottom, 40)

                dateInputSection
                    .padding(.bottom, 40)

                if viewModel.editorMode == .create || !viewModel.isSharedStaccato {
                    categorySelectSection
                        .padding(.bottom, 40)
                }

                saveButton
            }
            .padding(.horizontal, 24)
        }
        .dismissKeyboardOnGesture()
        .scrollIndicators(.hidden)

        .onAppear {
            if viewModel.editorMode == .create,
               STLocationManager.shared.hasLocationAuthorization() {
                STLocationManager.shared.getCurrentPlaceInfo { place in
                    self.viewModel.selectedPlace = place
                }
            }
        }

        .onChange(of: viewModel.showDatePickerSheet) { _, newValue in
            if !newValue,
               viewModel.selectedDate != viewModel.dateOnDatePicker {
                viewModel.selectedDate = viewModel.dateOnDatePicker
            }
        }

        .onChange(of: viewModel.selectedDate) {
            viewModel.getCategoryCandidates()
        }
        
        .staccatoModalBar(
            title:
                viewModel.editorMode == .create ? "스타카토 기록하기" : "스타카토 수정하기",
            subtitle:
                viewModel.editorMode == .create ? "기억하고 싶은 순간을 남겨보세요!" : "기억하고 싶은 순간을 수정해 보세요!"
        )
        
        .sheet(isPresented: $viewModel.showPlaceSearchSheet) {
            GMSPlaceSearchViewController { place in
                self.viewModel.selectedPlace = place
            }
        }
        
        .alert(isPresented: $isPhotoFull) {
            Alert(title: Text("사진은 최대 8장만 첨부할 수 있어요!"),
                  message: nil,
                  dismissButton: .default(Text("확인")) { isPhotoFull = false })
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

        .alert("위치 권한 필요", isPresented: $showLocationAlert) {
            Button("설정 열기") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("Staccato 사용을 위해 설정에서 위치 접근 권한을 허용해주세요.")
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .pushNotificationReceived)) { _ in
            dismiss()
        }
    }
}


// MARK: - UI Components

extension StaccatoEditorView {

    // MARK: - Photo

    private var photoInputSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text("사진")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Text("(\(viewModel.photos.count)/8)")
                    .foregroundStyle(.gray3)
                    .typography(.body4)

                Spacer()
            }
            .padding(.bottom, 16)

            photoInputGrid

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
        
        .alert(viewModel.errorTitle ?? "", isPresented: $viewModel.catchError) {
            Button("확인") {
                viewModel.catchError = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }
        
        .photosPicker(isPresented: $viewModel.isPhotoPickerPresented,
                      selection: $viewModel.selectedPhotos,
                      maxSelectionCount: 8 - viewModel.photos.count,
                      matching: .images)
        
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            CameraView(cameraMode: .multiple, imageList: self.$viewModel.photos)
                .background(.black)
        }
        
        .onChange(of: viewModel.uploadSuccess, { _, uploadSuccess in
            if uploadSuccess { dismiss() }
        })

        .onChange(of: viewModel.selectedPhotos) { _, _ in
            viewModel.loadTransferable()
        }
    }
    
    private var photoInputGrid: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 7) {
            photoInputPlaceholder

            ForEach(viewModel.photos, id: \.id) { photo in
                photoPreview(photo: photo)
            }
        }
        .padding(0)
    }

    private var photoInputPlaceholder: some View {
        Button {
            if viewModel.photos.count < 8 {
                viewModel.isPhotoInputPresented = true
            } else {
                isPhotoFull = true
            }
        } label: {
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    Image(.camera)
                        .frame(width: 18)

                    Text("사진을\n첨부해 보세요")
                        .typography(.body4)
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
            let photoImage = Image(uiImage: photo.photo)
                .resizable()
                .scaledToFill()
                .clipShape(.rect(cornerRadius: 5))
                .frame(width: geometry.size.width - 5, height: geometry.size.width - 5)

            ZStack {
                photoImage
                    .opacity(viewModel.draggingPhoto?.id == photo.id ? 0.6 : 1.0)

                if photo.isUploading {
                    Color.staccatoWhite.opacity(0.8)
                    LottieView(animation: .named("UploadImage"))
                        .playing(loopMode: .loop)
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
                        .frame(width: 20, height: 20)
                        .offset(x: 4, y: -4)
                }
            }

            .draggable(photo.id.uuidString) {
                photoImage // Drag preview
                    .opacity(0.6)
                    .onAppear {
                        viewModel.draggingPhoto = photo
                    }
            }
            .dropDestination(for: String.self) { items, location in
                viewModel.draggingPhoto = nil
                return false
            } isTargeted: { status in
                if let draggingItem = viewModel.draggingPhoto, status, draggingItem != photo {
                    if let sourceIndex = viewModel.photos.firstIndex(of: draggingItem),
                       let destination = viewModel.photos.firstIndex(of: photo) {
                        withAnimation(.bouncy) {
                            let sourceItem = viewModel.photos.remove(at: sourceIndex)
                            viewModel.photos.insert(sourceItem, at: destination )
                        }
                    }
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
                if STLocationManager.shared.hasLocationAuthorization() {
                    STLocationManager.shared.getCurrentPlaceInfo { place in
                        self.viewModel.selectedPlace = place
                    }
                } else {
                    showLocationAlert = true
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
                DatePickerView(selectedDate: $viewModel.dateOnDatePicker)
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }

    // MARK: - Category

    private var categorySelectSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "카테고리 선택")
            
            Button(viewModel.categories.isEmpty
                   ? "생성된 카테고리가 없어요"
                   : viewModel.selectedCategory?.categoryTitle ?? "카테고리를 선택해주세요") {
                viewModel.showCategoryPickerSheet = viewModel.categories.isEmpty ? false : true
            }
            .buttonStyle(viewModel.selectedCategory == nil ? .staticTextFieldButtonStyle() : .staticTextFieldButtonStyle(isActive: true))
    
            .sheet(isPresented: $viewModel.showCategoryPickerSheet) {
                SelectCategoryView(
                 selectedCategory: $viewModel.selectedCategory,
                 categories: $viewModel.categories
                )
                .presentationDetents([.fraction(0.4)])
            }
        }
    }

    // MARK: - Save

    private var saveButton: some View {
        Button("저장") {
            Task {
                switch viewModel.editorMode {
                case .create:
                    await viewModel.saveStaccato(.create)
                    homeViewModel.fetchStaccatos()
                case .modify(let id):
                    await viewModel.saveStaccato(.modify(id: id))

                    // 마커 좌표 업데이트
                    if let newCoordinate = viewModel.selectedPlace?.coordinate {
                        homeViewModel.updateMarkersPosition(for: id, to: newCoordinate)
                    }
                }
            }
        }
        .buttonStyle(.staccatoFullWidth)
        .disabled(!viewModel.isReadyToSave || viewModel.isSaving)
    }

}


// MARK: - Helper

private extension StaccatoEditorView {

    // MARK: SectionTitle generator

    private func sectionTitle(title: String) -> some View {
        return Group {
            Text(title)
                .foregroundStyle(.staccatoBlack)
            + Text(" *")
                .foregroundStyle(.staccatoBlue)
        }
        .typography(.title2)
        .padding(.bottom, 8)
    }

}
