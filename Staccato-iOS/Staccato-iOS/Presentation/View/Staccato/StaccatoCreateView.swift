//
//  StaccatoCreateView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/20/25.
//

import SwiftUI
import PhotosUI

import Lottie

@MainActor
@Observable
class UploadablePhoto: Identifiable, Equatable {
    let id: UUID = UUID()
    let photo: UIImage

    var isUploading = false
    var isFailed = false
    var imageURL: String?

    init(photo: UIImage) {
        self.photo = photo
    }

    nonisolated static func == (lhs: UploadablePhoto, rhs: UploadablePhoto) -> Bool {
        return lhs.id == rhs.id
    }

    func uploadImage() async throws {
        isUploading = true
        print("여기임")
        defer {
            isUploading = false
        }

        do {
            let imageURL = try await NetworkService.shared.uploadImage(self.photo)
            self.imageURL = imageURL.imageUrl
            print("성공")
        } catch {
            isFailed = true
            print("실패")
            throw error
        }
    }
}

struct StaccatoCreateView: View {
    @State var title: String = ""
    @State private var showPlaceSearchSheet = false
    @State private var selectedPlace: StaccatoPlaceModel?
    @State var showDatePickerSheet = false
    @State var selectedDate: Date?
    @FocusState var isTitleFocused: Bool

    @State var catchError: Bool = false
    @State var errorTitle: String?
    @State var errorMessage: String?

    // MARK: Photo Input
    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    @State var photos: [UploadablePhoto] = []
    @State var isPhotoInputPresented = false
    @State var showCamera = false
    @State var isPhotoPickerPresented = false
    @State var photoItem: PhotosPickerItem?

    @State var isUploading = false

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
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .staccatoNavigationBar(
            title: "스타카토 기록하기",
            subtitle: "기억하고 싶은 순간을 남겨보세요!"
        )

        .sheet(isPresented: $showPlaceSearchSheet) {
            GMSPlaceSearchViewController { place in
                self.selectedPlace = place
            }
        }
        .alert(errorTitle ?? "", isPresented: $catchError) {
            Button("확인") {
                catchError = false
            }
        } message: {
            Text(errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }
    }
}

#Preview {
    StaccatoCreateView()
}

extension StaccatoCreateView {
    // MARK: - Photo
    private var photoInputSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text("사진")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Text("(\(photos.count)/5)")
                    .foregroundStyle(.gray3)
                    .typography(.body4)

                Spacer()
            }
            .padding(.bottom, 16)

            photoInputGrid

        }
        .confirmationDialog("사진을 첨부해 보세요", isPresented: $isPhotoInputPresented, titleVisibility: .visible, actions: {
            Button("카메라 열기") {
                showCamera = true
            }

            Button("앨범에서 가져오기") {
                isPhotoPickerPresented = true
            }
        })

        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photoItem)

        .fullScreenCover(isPresented: $showCamera) {
            CameraView(cameraMode: .multiple, imageList: self.$photos)
                .background(.black)
        }

        .onChange(of: photoItem) { _, newValue in
            Task {
                await loadTransferable(from: newValue)
            }
        }

        .onChange(of: photos) { oldValue, newValue in
            Task {
                if oldValue.count < newValue.count {
                    if let lastIndex = newValue.indices.last {
                        do {
                            try await photos[lastIndex].uploadImage()
                        } catch {
                            self.errorTitle = "이미지 업로드 실패"
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        }
    }

    private var photoInputGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            photoInputPlaceholder

            ForEach(photos, id: \.id) { photo in
                photoPreview(photo: photo)
            }
        }
        .padding(0)
    }

    private var photoInputPlaceholder: some View {
        Button {
            isPhotoInputPresented = true
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
                        Color.white.opacity(0.8)
                        LottieView(animation: .named("UploadImage"))
                            .playing(loopMode: .loop)
                    }
                }

                if photo.isFailed {
                    ZStack {
                        Color.white.opacity(0.8)
                        Image(.photoBadgeExclamationmark)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 78)
                    }
                }
            }
            .frame(width: geometry.size.width - 5, height: geometry.size.width - 5)
            .clipShape(.rect(cornerRadius: 5))
            .overlay(alignment: .topTrailing) {
                Button {
                    if let index = photos.firstIndex(of: photo) {
                        withAnimation {
                            _ = photos.remove(at: index)
                        }
                    }
                } label: {
                    Image(.minusCircle)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .gray3)
                        .background(Circle().fill(.white))
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
                text: $title,
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

            Button(selectedPlace?.name ?? "장소명, 주소, 위치로 검색해보세요") {
                showPlaceSearchSheet = true
            }
            .buttonStyle(.staticTextFieldButtonStyle(icon: .magnifyingGlass,
                                                     isActive: selectedPlace != nil))
            .padding(.bottom, 10)

            Text("상세 주소")
                .typography(.title3)
                .foregroundStyle(.staccatoBlack)
                .padding(.bottom, 6)

            Text(selectedPlace?.address ?? "상세주소는 여기에 표시됩니다.")
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
                    self.selectedPlace = place
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

            Button(selectedDate?.formattedAsFullDateWithHour ?? "방문 날짜를 선택해주세요") {
                showDatePickerSheet = true
            }
            .buttonStyle(.staticTextFieldButtonStyle())

            .sheet(isPresented: $showDatePickerSheet) {
                DatePickerView(selectedDate: $selectedDate)
                    .presentationDetents([.fraction(0.4)])
            }
        }
    }

    // MARK: - Category
    private var categorySelectSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "카테고리 선택")

            Button("카테고리를 선택해주세요") {

            }
            .buttonStyle(.staticTextFieldButtonStyle())
        }
    }

    // MARK: - Save
    private var saveButton: some View {
        Button("저장") {

        }
        .buttonStyle(.staccatoFullWidth)
        .disabled(true)
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

extension StaccatoCreateView {
    func loadTransferable(from imageSelection: PhotosPickerItem?) async {
        do {
            if let imageData = try await imageSelection?.loadTransferable(type: Data.self) {
                guard let transferedImage = UIImage(data: imageData) else { throw StaccatoError.imageParsingFailed }

                self.photos.append(UploadablePhoto(photo: transferedImage))
                self.photoItem = nil
            }
        } catch {
            print(error.localizedDescription)
            errorTitle = "이미지 업로드 실패"
            errorMessage = error.localizedDescription
            catchError = true
        }
    }
}
