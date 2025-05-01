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
    @Bindable private var vm: CategoryEditorViewModel

    @FocusState private var isTitleFocused: Bool

    @FocusState private var isDescriptionFocused: Bool

    init(
        categoryDetail: CategoryDetailModel? = nil,
        editorType: CategoryEditorViewModel.CategoryEditorType = .create,
        categoryViewModel: CategoryViewModel
    ) {
        self.vm = CategoryEditorViewModel(
            categoryDetail: categoryDetail,
            editorType: editorType,
            categoryViewModel: categoryViewModel
        )
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

                    periodSettingSection
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 4)

                Spacer()

                Button("저장") {
                    Task {
                        switch vm.editorType {
                        case .create:
                            await vm.createCategory()
                            dismiss()
                        case .modify:
                            await vm.modifyCategory()
                            dismiss()
                        }
                    }
                }
                .buttonStyle(.staccatoFullWidth)
                .disabled(vm.isSubmitButtonDisabled)
            }
            .animation(.easeIn(duration: 0.15), value: vm.isPeriodSettingActive)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
        .staccatoModalBar(
            title: "카테고리 만들기",
            subtitle: "스타카토를 담을 카테고리를 만들어 보세요!"
        )
        .ignoresSafeArea(.all, edges: .bottom)

        .sheet(isPresented: $vm.isPeriodSheetPresented) {
            StaccatoDatePicker(isDatePickerPresented: $vm.isPeriodSheetPresented, selectedStartDate: $vm.selectedStartDate, selectedEndDate: $vm.selectedEndDate)
        }

        .alert(vm.errorTitle ?? "", isPresented: $vm.catchError) {
            Button("확인") {
                vm.catchError = false
            }
        } message: {
            Text(vm.errorMessage ?? "알 수 없는 에러입니다.\n다시 한 번 확인해주세요.")
        }

        .alert("카테고리 생성 성공", isPresented: $vm.uploadSuccess) {
            Button("확인") {
                dismiss()
            }
        } message: {
            Text("이미지 업로드에 성공했습니다!\n이제 스타카토를 함께 쌓아나가보세요!")
        }

    }
}

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
            startAt: "2024-01-01",
            endAt: "2024-01-30",
            mates: [],
            staccatos: []
        ),
        editorType: .modify,
        categoryViewModel: CategoryViewModel()
    )
    .environment(NavigationState())
}

// MARK: - Section
extension CategoryEditorView {
    // MARK: Photo Section
    private var photoSection: some View {
        Button {
            vm.isPhotoInputPresented = true
        } label: {
            if let photo = vm.selectedPhoto {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            } else {
                photoPlaceholder
            }
        }
        .frame(height: 200)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.top, 12)
        .onChange(of: vm.photoItem) { _, newValue in
            Task {
                await vm.loadTransferable(from: newValue)
                try await vm.uploadImage()
            }
        }

        .confirmationDialog("사진을 첨부해 보세요", isPresented: $vm.isPhotoInputPresented, titleVisibility: .visible, actions: {
            Button("카메라 열기") {
                vm.showCamera = true
            }

            Button("앨범에서 가져오기") {
                vm.isPhotoPickerPresented = true
            }
        })

        .photosPicker(isPresented: $vm.isPhotoPickerPresented, selection: $vm.photoItem)

        .fullScreenCover(isPresented: $vm.showCamera) {
            CameraView(selectedImage: $vm.selectedPhoto)
                .background(.staccatoBlack)
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
                    .foregroundStyle(.accent)
            }
            .typography(.title2)
            .padding(.bottom, 8)

            StaccatoTextField(
                text: $vm.categoryTitle,
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

            TextEditor(text: $vm.categoryDescription)
                .staccatoTextEditorStyle(
                    placeholder: "카테고리 소개를 입력해주세요(최대 500자)",
                    text: $vm.categoryDescription,
                    maximumTextLength: 500,
                    isFocused: $isDescriptionFocused
                )
                .focused($isDescriptionFocused)
        }
    }

    // MARK: Period Setting Section
    private var periodSettingSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("기간 설정")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Spacer()

                Toggle("", isOn: $vm.isPeriodSettingActive)
                    .toggleStyle(StaccatoToggleStyle())
            }

            Text("'여행'과 같은 카테고리라면 기간을 선택할 수 있어요.")
                .typography(.body4)
                .foregroundStyle(.gray3)
                .padding(.bottom, 12)

            if vm.isPeriodSettingActive {
                Button {
                    vm.isPeriodSheetPresented = true
                } label: {
                    Text(vm.categoryPeriod ?? "카테고리 기간을 선택해주세요")
                        .foregroundStyle(vm.categoryPeriod == nil ? .gray3 : .staccatoBlack)
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
}
