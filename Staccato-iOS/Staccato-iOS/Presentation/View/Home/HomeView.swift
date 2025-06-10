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
    @EnvironmentObject private var detentManager: BottomSheetDetentManager
    @Environment(NavigationState.self) private var navigationState
    @Environment(StaccatoAlertManager.self) private var alertManager
    @State private var locationAuthorizationManager = STLocationManager.shared

    // NOTE: UI Visibility
    @State private var showUpdateAlert = false
    @State private var isMyPagePresented = false
    @State private var isCreateStaccatoPresented = false
    @State private var hasAppearedOnce = false
    @State private var hasNotification = false
    private var isStaccatoAddButtonVisible: Bool {
        detentManager.currentDetent != .large
    }


    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                mapView
                    .ignoresSafeArea(.all)
                    .environmentObject(detentManager)
                
                myPageButton
                    .padding(10)
                
                myLocationButton
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                
                staccatoAddButton
                    .position(
                        x: geometry.size.width - 40,
                        y: calculateFloatingButtonY(in: geometry)
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.8),
                               value: detentManager.currentDetent.height)
                
                if alertManager.isPresented {
                    StaccatoAlertView()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear() {
            if !hasAppearedOnce {
                hasAppearedOnce = true
                setupInitialState()
            } else {
                refreshDataOnly()
            }
            
            STNotificationManager.shared.getHasNotification { hasNotificaton in
                self.hasNotification = hasNotificaton
            }
            
            detentManager.isbottomSheetPresented = true
        }
        .sheet(isPresented: $detentManager.isbottomSheetPresented) {
            CategoryListView(navigationState)
                .environmentObject(detentManager)
                .interactiveDismissDisabled(true)
                .presentationContentInteraction(.scrolls)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents(
                    Set(BottomSheetDetent.allCases.map { $0.detent }),
                    selection: $detentManager.selectedDetent
                )
        }
        .fullScreenCover(isPresented: $isMyPagePresented) {
            MyPageView()
                .onDisappear {
                    detentManager.isbottomSheetPresented = true
                }
        }
        .fullScreenCover(isPresented: $isCreateStaccatoPresented) {
            StaccatoEditorView(category: nil)
                .onDisappear {
                    detentManager.isbottomSheetPresented = true
                }
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
        .onDisappear {
            hasAppearedOnce = false
        }
    }
}

// MARK: - UI Components
private extension HomeView {

    var myPageButton: some View {
        Button {
            detentManager.isbottomSheetPresented = false
            isMyPagePresented = true
        } label: {
            ZStack(alignment: .topTrailing) {
                KFImage(URL(string: mypageViewModel.profile?.profileImageUrl ?? ""))
                    .fillPersonImage(width: 40, height: 40)
                    .background(Color.staccatoWhite)
                    .foregroundStyle(.gray3)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.staccatoWhite, lineWidth: 2)
                    }
                
                if hasNotification {
                    Circle()
                        .fill(Color.accentRed)
                        .frame(width: 10, height: 10)
                        .offset(x: 4, y: -4)
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
            detentManager.isbottomSheetPresented = false
            isCreateStaccatoPresented = true
        } label: {
            Image(.plus)
                .resizable()
                .fontWeight(.semibold)
                .frame(width: 20, height: 20)
                .foregroundStyle(.staccatoWhite)
        }
        .frame(width: 44, height: 44)
        .background(.staccatoBlue)
        .clipShape(.circle)
        .shadow(radius: 4, y: 4)
    }
}

private extension HomeView {
    func setupInitialState() {
        // TODO: - 리팩토링
        // 앱 버전체크
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
    
    func refreshDataOnly() {
        viewModel.fetchStaccatos()
        mypageViewModel.fetchProfile()
    }
    
    func calculateFloatingButtonY(in geometry: GeometryProxy) -> CGFloat {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let defaultY = geometry.size.height - safeAreaBottom - 12
        
        guard detentManager.isbottomSheetPresented && detentManager.currentDetent.height > 0 else {
            return defaultY
        }
        
        let sheetTopY = geometry.size.height - detentManager.currentDetent.height - safeAreaBottom
        let buttonOffset: CGFloat = 12
        
        return max(sheetTopY - buttonOffset, 100)
    }
}
