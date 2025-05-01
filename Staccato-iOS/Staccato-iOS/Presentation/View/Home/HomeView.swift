//
//  HomeView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct HomeView: View {

    // MARK: - Properties
    //NOTE: View, ViewModel
    @EnvironmentObject var viewModel: HomeViewModel
    private let mapView = GMSMapViewRepresentable()

    // NOTE: 모달 크기
    @State private var modalHeight: CGFloat = HomeModalSize.medium.height
    @State private var dragOffset: CGFloat = 120 / 640 * ScreenUtils.height

    // NOTE: 화면 전환, Alert 매니저
    @Environment(NavigationState.self) var navigationState
    @Environment(StaccatoAlertManager.self) var alertManager
    @State private var isMyPagePresented = false

    // NOTE: 위치 접근 권한
    @State private var locationAuthorizationManager = STLocationManager.shared

    // NOTE: Staccato Create Modal
    @State private var isCreateStaccatoModalPresented = false


    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            mapView
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, modalHeight - 40)

            myPageButton
                .padding(10)
            
            myLocationButton
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .topTrailing)

            staccatoAddButton
                .padding(.trailing, 12)
                .padding(.bottom, modalHeight - 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            categoryListModal
                .edgesIgnoringSafeArea(.bottom)
            if alertManager.isPresented {
                StaccatoAlertView()
            }
        }
        .onAppear() {
            locationAuthorizationManager.checkLocationAuthorization()
            STLocationManager.shared.updateLocationForOneSec()
            viewModel.fetchStaccatos()
        }
        .onChange(of: locationAuthorizationManager.hasLocationAuthorization) { oldValue, newValue in
            if newValue {
                STLocationManager.shared.updateLocationForOneSec()
            }
        }
        .fullScreenCover(isPresented: $isMyPagePresented) {
            MyPageView()
        }
        .fullScreenCover(isPresented: $isCreateStaccatoModalPresented) {
            StaccatoEditorView(category: nil)
        }
    }

}


// MARK: - UI Components

extension HomeView {

    private var myPageButton: some View {
        Button {
            isMyPagePresented = true
        } label: {
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

    private var myLocationButton: some View {
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

    private var staccatoAddButton: some View {
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

    private var categoryListModal: some View {
        VStack {
            Spacer()

            CategoryListView(navigationState)
                .frame(height: modalHeight)
                .background(Color.staccatoWhite)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
                .shadow(color: .black.opacity(0.15), radius: 8, y: -1)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 드래그 중에 모달의 높이를 변경
                            let newHeight = max(100, modalHeight - value.translation.height)
                            modalHeight = newHeight
                        }
                        .onEnded { value in
                            // 드래그 종료 후, 모달의 최종 높이를 설정
                            if modalHeight < HomeModalSize.small.height + dragOffset {
                                modalHeight = HomeModalSize.small.height  // small
                            } else if modalHeight < HomeModalSize.medium.height + dragOffset {
                                modalHeight = HomeModalSize.medium.height  // medium
                            } else {
                                modalHeight = HomeModalSize.large.height  // large
                            }
                        }
                )
        }
    }
}
