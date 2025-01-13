//
//  HomeView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct HomeView: View {
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                MapViewControllerBridge()
                    .edgesIgnoringSafeArea(.all)
                
                myPageNavigationLink
                    .padding(20)
            }
        }
    }
}


// MARK: - Components
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
}

#Preview {
    HomeView()
}



// 임시 뷰 - 추후 삭제 예정
struct TempMyPageView: View {
    var body: some View {
        Text("My Page")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}
