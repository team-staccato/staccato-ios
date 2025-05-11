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
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var mypageViewModel: MyPageViewModel
    private let mapView = GMSMapViewRepresentable()

    // NOTE: 모달 크기
    @Environment(HomeModalManager.self) var homeModalManager

    // NOTE: 화면 전환, Alert 매니저
    @Environment(NavigationState.self) var navigationState
    @Environment(StaccatoAlertManager.self) var alertManager
    @State private var isMyPagePresented = false

    // NOTE: 위치 접근 권한
    @State private var locationAuthorizationManager = STLocationManager.shared

    // NOTE: Staccato Create Modal
    @State private var isCreateStaccatoModalPresented = false

    // NOTE: 앱 업데이트 Alert 여부
    @State private var showUpdateAlert = false


    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            mapView
                .background(Color.red)
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, homeModalManager.modalHeight - 40)

            myPageButton
                .padding(10)
            
            myLocationButton
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .topTrailing)

            staccatoAddButton
                .padding(.trailing, 12)
                .padding(.bottom, homeModalManager.modalHeight - 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

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
                .fontWeight(.bold)
                .frame(width: 25, height: 25)
                .foregroundStyle(.staccatoWhite)
        }
        .frame(width: 48, height: 48)
        .background(.accent)
        .clipShape(.circle)
        .shadow(radius: 4, y: 4)
    }

    var categoryListModal: some View {
        VStack {
            Spacer()

            CategoryListView(navigationState)
                .frame(height: homeModalManager.modalHeight)
                .background(Color.staccatoWhite)
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
