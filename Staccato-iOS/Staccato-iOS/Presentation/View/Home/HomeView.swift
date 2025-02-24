//
//  HomeView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct HomeView: View {
    
    // MARK: - State for Modal
    
    @State private var modalHeight: CGFloat = HomeModalSize.medium.height
    @State private var dragOffset: CGFloat = 120 / 640 * ScreenUtils.height
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GMSMapViewRepresentable.shared
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, modalHeight - 40)
            
            myPageNavigationLink
                .padding(10)
            
            categoryListModal
                .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            LocationAuthorizationManager.shared.checkLocationAuthorization()
        }
    }
}


// MARK: - UI Components

extension HomeView {
    
    private var myPageNavigationLink: some View {
        NavigationLink(destination: TempMyPageView()) {
            Image(systemName: "person.circle.fill")
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
    
    private var categoryListModal: some View {
        VStack {
            Spacer()
            
            CategoryListView()
                .frame(height: modalHeight)
                .background(Color.white)
                .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
                .shadow(radius: 5)
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


// TODO: 추후 삭제
struct TempMyPageView: View {
    var body: some View {
        Text("My Page")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}
