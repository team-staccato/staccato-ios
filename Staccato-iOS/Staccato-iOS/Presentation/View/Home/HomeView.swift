//
//  HomeView.swift
//  Staccato-iOS
//
//  Created by 김유림 on 1/9/25.
//

import GoogleMaps

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                MapViewControllerBridge()
                    .edgesIgnoringSafeArea(.all)
                
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
                .padding(20)
            }
        }
    }
}

struct TempMyPageView: View {
    var body: some View {
        Text("My Page")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
    }
}

#Preview {
    HomeView()
}
