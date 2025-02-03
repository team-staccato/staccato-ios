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
    
        @State private var modalHeight: CGFloat = 200  // 기본 모달 높이
        @State private var dragOffset: CGFloat = 0      // 드래그 오프셋
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                MapViewControllerBridge()
                    .edgesIgnoringSafeArea(.all)
                
                myPageNavigationLink
                    .padding(20)
                
                categoryListModal
                    .edgesIgnoringSafeArea(.all)
            }
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
                .cornerRadius(20)
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
                            if modalHeight < 200 {
                                modalHeight = 100  // 짧은 형태
                            } else if modalHeight < 500 {
                                modalHeight = 320  // 중간 형태
                            } else {
                                modalHeight = 700  // 큰 형태
                            }
                        }
                )
        }
        
    }
    
}

#Preview {
    HomeView()
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
