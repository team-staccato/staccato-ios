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
    //NOTE: 뷰모델
    @StateObject private var viewModel = HomeViewModel()
    // NOTE: 모달
    @State private var modalHeight: CGFloat = HomeModalSize.medium.height
    @State private var dragOffset: CGFloat = 120 / 640 * ScreenUtils.height
    
    // NOTE: 화면 전환
    @State private var isMyPagePresented = false
    
    // NOTE: 위치 접근 권한
    @State private var locationAuthorizationManager = LocationAuthorizationManager.shared
    
    private let googleMapView = GMSMapViewRepresentable()
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            googleMapView
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
        }
        .onAppear() {
            locationAuthorizationManager.checkLocationAuthorization()
            viewModel.updateLocationForOneSec()
            viewModel.fetchStaccatos()
        }
        .onChange(of: locationAuthorizationManager.hasLocationAuthorization) { oldValue, newValue in
            if newValue {
                viewModel.updateLocationForOneSec()
            }
        }
        .fullScreenCover(isPresented: $isMyPagePresented) {
            MyPageView()
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
                .background(Color.white)
                .foregroundStyle(.gray3)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.white, lineWidth: 2)
                }
        }
    }
    
    private var myLocationButton: some View {
        Button {
            viewModel.updateLocationForOneSec()
        } label: {
            Image(.dotScope)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray4)
        }
        .frame(width: 38, height: 38)
        .background(.white)
        .clipShape(.circle)
        .shadow(radius: 2)
    }
    
    private var staccatoAddButton: some View {
        Button {
            viewModel.categoryNavigationState.navigate(to: .staccatoAdd)
            // TODO: modal fullScreen mode
        } label: {
            Image(.plus)
                .resizable()
                .fontWeight(.bold)
                .frame(width: 25, height: 25)
                .foregroundStyle(.white)
        }
        .frame(width: 48, height: 48)
        .background(.accent)
        .clipShape(.circle)
        .shadow(radius: 4, y: 4)
    }
    
    private var categoryListModal: some View {
        VStack {
            Spacer()
            
            CategoryListView(viewModel.categoryNavigationState)
                .frame(height: modalHeight)
                .background(Color.white)
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
