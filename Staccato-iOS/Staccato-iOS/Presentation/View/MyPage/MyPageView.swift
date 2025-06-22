//
//  MyPageView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/14/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct MyPageView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(NavigationState.self) var navigationState
    @EnvironmentObject private var viewModel: MyPageViewModel
    @EnvironmentObject private var signinViewModel: SignInViewModel
    
    @State var copyButtonPressed = false
    @State var isPhotoInputPresented = false
    @State var showCamera = false
    @State var isPhotoPickerPresented = false
    @State private var showSettingAlert: Bool = false
    
    @State private var photoItem: PhotosPickerItem?
    @State private var capturedImage: UIImage?
    @State private var selectedPhoto: UIImage?
    @State private var showToast = false
    @State private var hasNotification = false
    
    var body: some View {
        NavigationView {
            VStack {
                profileImageSection
                    .padding(.bottom, 24)
                    .padding(.top, 35)
                
                userNameSection
                    .padding(.bottom, 16)
                
                recoveryCodeCopyButton
                    .padding(.bottom, 40)
                
                Divider()
                
                menuSection
                
                Spacer()
            }
            .staccatoModalBar(title: "마이페이지", titlePosition: .center)
            .overlay(
                Group {
                    if showToast {
                        toastMessage
                    }
                },
                alignment: .bottom
            )
            .onAppear {
                STNotificationManager.shared.getHasNotification { hasNotificaton in
                    self.hasNotification = hasNotificaton
                }
                
                viewModel.fetchProfile()
            }
        }
    }
}

extension MyPageView {
    private var profileImageSection: some View {
        Button {
            isPhotoInputPresented = true
        } label: {
            KFImage.url(URL(string: viewModel.profile?.profileImageUrl ?? ""))
                .fillPersonImage(width: 84, height: 84)
                .overlay(alignment: .bottomTrailing) {
                    Image(.pencilCircleFill)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray5)
                        .frame(width: 20, height: 20)
                }
            
        }
        
        .confirmationDialog("프로필 이미지를 변경해요", isPresented: $isPhotoInputPresented, titleVisibility: .visible, actions: {
            Button("카메라 열기") {
                CameraView.checkCameraPermission { granted in
                    if granted {
                        showCamera = granted
                    } else {
                        showSettingAlert = true
                    }
                }
            }
            
            Button("앨범에서 가져오기") {
                isPhotoPickerPresented = true
            }
        })
        
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photoItem)
        
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(selectedImage: $capturedImage)
                .background(.staccatoBlack)
        }
        
        .alert(isPresented: $showSettingAlert) {
            Alert(
                title: Text("현재 카메라 사용에 대한 접근 권한이 없습니다."),
                message: Text("설정 > {앱 이름} 탭에서 접근을 활성화 할 수 있습니다."),
                primaryButton: .default(Text("설정으로 이동"), action: {
                    openURL(URL(string: UIApplication.openSettingsURLString)!)
                }),
                secondaryButton: .cancel(Text("취소"))
            )
        }
        
        .onChange(of: capturedImage, { _, newValue in
            loadTransferable(from: newValue)
        })
        
        .onChange(of: photoItem) { _, newValue in
            loadTransferable(from: newValue)
        }
    }
    
    private var userNameSection: some View {
        Text(viewModel.profile?.nickname ?? "")
            .typography(.body1)
            .foregroundStyle(.staccatoBlack)
    }
    
    private var recoveryCodeCopyButton: some View {
        Button {
            UIPasteboard.general.string = "복구코드 붙여넣기"
            copyButtonPressed.toggle()
            UIPasteboard.general.string = viewModel.profile?.code ?? ""
            withAnimation { showToast = true }
            
            Task {
                try await Task.sleep(for: .seconds(1))
                withAnimation { showToast = false }
            }
        } label: {
            HStack(spacing: 10) {
                Text("복구 코드 복사하기")
                    .foregroundStyle(.gray3)
                
                Image(.squareOnSquare)
                    .scaleEffect(x: -1)
                    .foregroundStyle(.gray4)
            }
        }
        .sensoryFeedback(.success, trigger: copyButtonPressed)
        .typography(.body2)
    }
    
    
    private var toastMessage: some View {
        Text("복구 코드가 복사되었습니다.")
            .padding()
            .background(Color.staccatoBlack.opacity(0.8))
            .foregroundColor(.staccatoWhite)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 50)
            .transition(.opacity)
    }
    
    private var menuSection: some View {
        VStack {
            NavigationLink {
                CategoryInvitationManagerView()
            } label: {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        Text("카테고리 초대 관리")
                            .typography(.title3)
                            .foregroundStyle(.staccatoBlack)
                        if hasNotification {
                            Circle()
                                .fill(Color.accentRed)
                                .frame(width: 5, height: 5)
                                .offset(x: 10, y: -6)
                        }
                    }
                    
                    Spacer()
                    
                    Image(.chevronRight)
                        .foregroundStyle(.gray2)
                }
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 24)
            
            Rectangle()
                .fill(Color.gray1)
                .frame(height: 10)
            
            NavigationLink {
                EmbedWebView(title: "개인정보처리방침", urlString: WebViewURLs.privacyPolicy)
            } label: {
                HStack {
                    Text("개인정보처리방침")
                        .typography(.title3)
                        .foregroundStyle(.staccatoBlack)
                    
                    Spacer()
                    
                    Image(.chevronRight)
                        .foregroundStyle(.gray2)
                }
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 24)
            
            
            Divider()
            
            NavigationLink {
                EmbedWebView(title: "피드백으로 혼내주기", urlString: WebViewURLs.feedback)
            } label: {
                HStack {
                    Text("피드백으로 혼내주기")
                        .typography(.title3)
                        .foregroundStyle(.staccatoBlack)
                    
                    Spacer()
                    
                    Image(.chevronRight)
                        .foregroundStyle(.gray2)
                }
                .padding(.vertical, 26)
                .padding(.horizontal, 24)
            }
            
            Divider()
            
            HStack {
                Text("앱 버전 \(Bundle.main.appVersion)")
                    .typography(.body4)
                    .foregroundStyle(.gray4)
                    .padding(.leading, 24)
                
                Spacer()
                
                Button {
                    let instagramUrl = URL(string: WebViewURLs.instagramApp)!
                    if UIApplication.shared.canOpenURL(instagramUrl) {
                        UIApplication.shared.open(instagramUrl)
                    } else {
                        UIApplication.shared.open(URL(string: WebViewURLs.instagramWeb)!)
                    }
                } label: {
                    Image(.instagramLogo)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 12)
#if DEBUG
            Spacer()
            logoutButton
#endif
        }
    }
}

extension MyPageView {
    private func loadTransferable(from imageSelection: PhotosPickerItem?) {
        Task {
            if let imageData = try? await imageSelection?.loadTransferable(type: Data.self) {
                let image = UIImage(data: imageData)
                viewModel.uploadProfileImage(image!)
                selectedPhoto = image
            }
        }
    }
    private func loadTransferable(from image: UIImage?) {
        Task {
            viewModel.uploadProfileImage(image!)
            selectedPhoto = image
        }
    }
}


// MARK: - 디버깅용 코드

extension MyPageView {
    
    var logoutButton: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 10) {
                Button {
                    print("\n========================================\n✅ 복구코드: \(viewModel.profile?.code ?? "없음")\n====================로그아웃====================")
                    UIPasteboard.general.string = viewModel.profile?.code ?? "복구코드 없음"
                    signinViewModel.logout()
                } label: {
                    Text("로그아웃")
                        .typography(.title2)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                }
                .background(RoundedRectangle(cornerRadius: 2).stroke(.red))
                
                Text("복구코드는 복사되며 콘솔창에도 프린트됩니다.")
                    .typography(.body4)
                    .foregroundStyle(.gray4)
            }
        }
        .padding(.horizontal, 20)
    }
    
}
