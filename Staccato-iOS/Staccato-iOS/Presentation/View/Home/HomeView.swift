//
//  HomeView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import SwiftUI

import GoogleMaps
import Kingfisher

struct HomeView: View {

    // MARK: - Properties

    //NOTE: View, ViewModel
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var mypageViewModel: MyPageViewModel
    private let mapView = GMSMapViewRepresentable()

    // NOTE: Managers
    @Environment(HomeModalManager.self) private var homeModalManager
    @Environment(NavigationState.self) private var navigationState
    @Environment(StaccatoAlertManager.self) private var alertManager
    @State private var locationAuthorizationManager = STLocationManager.shared

    // NOTE: UI Visibility
    @State private var showUpdateAlert = false
    @State private var isMyPagePresented = false
    @State private var isCreateStaccatoModalPresented = false
    private var isStaccatoAddButtonVisible: Bool {
        homeModalManager.modalSize != .large
    }


    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            mapView
                .background(Color.red)
                .edgesIgnoringSafeArea(.all)

            myPageButton
                .padding(10)
            
            myLocationButton
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .topTrailing)

            if isStaccatoAddButtonVisible {
                staccatoAddButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 12)
                    .padding(.bottom, (homeModalManager.modalHeight - ScreenUtils.safeAreaInsets.bottom) + 12)
            }

            categoryListModal
                .edgesIgnoringSafeArea(.bottom)
            
            if alertManager.isPresented {
                StaccatoAlertView()
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear() {
            // 앱 버전체크 // TODO: 리팩토링
            AppVersionCheckManager.shared.fetchAppStoreVersion { version in
                guard let appStoreVersion = version else {
                    print("❌ 버전 옵셔널 바인딩 실패")
                    return
                }
                showUpdateAlert = AppVersionCheckManager.shared.isUpdateAvailable(appStoreVersion: appStoreVersion)
            }

            locationAuthorizationManager.checkAndRequestLocationAuthorization()
            STLocationManager.shared.updateLocationForOneSec()
            viewModel.fetchStaccatos()
            mypageViewModel.fetchProfile()
        }
        .fullScreenCover(isPresented: $isMyPagePresented) {
            MyPageView()
        }
        .fullScreenCover(isPresented: $isCreateStaccatoModalPresented) {
            StaccatoEditorView(category: nil)
        }

        // 업데이트 안내 // TODO: 리팩토링
        .alert(isPresented: $showUpdateAlert) {
            Alert(
                title: Text("업데이트 필요"),
                message: Text("현재 버전은 앱이 정상적으로 작동하지 않습니다😢 \n새로운 버전으로 업데이트 해주세요."),
                dismissButton: .default(Text("업데이트하러 가기"), action: {
                    UIApplication.shared.open(AppVersionCheckManager.shared.appStoreURL)
                })
            )
        }
    }

}


// MARK: - UI Components

private extension HomeView {

    var myPageButton: some View {
        Button {
            isMyPagePresented = true
        } label: {
            if let profileImageUrl = mypageViewModel.profile?.profileImageUrl {
                KFImage(URL(string:  profileImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .background(Color.staccatoWhite)
                    .foregroundStyle(.gray3)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.staccatoWhite, lineWidth: 2)
                    }
            } else {
                Image(.personCircleFill)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .background(Color.staccatoWhite)
                    .foregroundStyle(.gray3)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.staccatoWhite, lineWidth: 2)
                    }
            }
        }
    }

    var myLocationButton: some View {
        Button {
            STLocationManager.shared.updateLocationForOneSec()
        } label: {
            Image(.dotScope)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray4)
        }
        .frame(width: 38, height: 38)
        .background(.staccatoWhite)
        .clipShape(.circle)
        .shadow(radius: 2)
    }

    var staccatoAddButton: some View {
        Button {
            isCreateStaccatoModalPresented = true
        } label: {
            Image(.plus)
                .resizable()
                .fontWeight(.semibold)
                .frame(width: 20, height: 20)
                .foregroundStyle(.staccatoWhite)
        }
        .frame(width: 44, height: 44)
        .background(.accent)
        .clipShape(.circle)
        .shadow(radius: 4, y: 4)
    }

    var categoryListModal: some View {
        VStack {
            Spacer()

            VStack(spacing: 0) {
                Capsule()
                    .frame(width: 48, height: 3)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    .foregroundStyle(.gray2)

                CategoryListView(navigationState)
            }
            .background(Color.staccatoWhite)
            .frame(maxHeight: homeModalManager.modalHeight)
            .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
            .shadow(color: .black.opacity(0.15), radius: 8, y: -1)

            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newHeight: CGFloat = homeModalManager.modalHeight - value.translation.height
                        homeModalManager.updateHeight(to: max(100, newHeight))
                    }
                    .onEnded { value in
                        homeModalManager.setFinalSize(translationAmount: value.translation.height)
                    }
            )
        }
    }

}
