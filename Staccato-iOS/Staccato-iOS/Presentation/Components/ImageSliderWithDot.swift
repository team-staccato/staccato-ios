//
//  ImageSliderWithDot.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import SwiftUI

import Kingfisher

struct ImageSliderWithDot: View {
    
    // MARK: - Properties
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    private let imageUrls: [String]
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let minimumDragDistance: CGFloat = 50
    
    init(images: [String], imageWidth: CGFloat, imageHeight: CGFloat) {
        self.imageUrls = images
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 12) {
            imageSlider
            dotCarousel
        }
    }
    
    
    // MARK: - UI Components
    
    var imageSlider: some View {
        HStack(spacing: 0) {
            ForEach(imageUrls.indices, id: \.self) { index in
                KFImage(URL(string: imageUrls[index]))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
            }
        }
        .frame(width: imageWidth, alignment: .leading)
        .offset(x: -CGFloat(currentIndex) * imageWidth + offset)
        .simultaneousGesture( // NOTE: 최상위 스크롤뷰 제스쳐 허용
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    // NOTE: 가로 스크롤만 핸들
                    if abs(value.translation.width) > abs(value.translation.height) {
                        offset = value.translation.width
                    }
                }
                .onEnded { value in
                    // NOTE: 가로 스크롤만 핸들
                    if abs(value.translation.width) > abs(value.translation.height) {
                        let dragAmount = value.translation.width
                        let maxIndex = imageUrls.count - 1
                        // 왼쪽으로 스와이프
                        if dragAmount < -minimumDragDistance && currentIndex < maxIndex {
                            withAnimation { currentIndex += 1 }
                        }
                        // 오른쪽으로 스와이프
                        if dragAmount > minimumDragDistance && currentIndex > 0 {
                            withAnimation { currentIndex -= 1 }
                        }
                        
                        // 오프셋 초기화
                        withAnimation { offset = 0 }
                    }
                }
        )
    }
    
    var dotCarousel: some View {
        HStack(spacing: 5) {
            ForEach(0..<imageUrls.count, id: \.self) { index in
                Circle()
                    .fill(currentIndex == index ? .gray3 : .gray2)
                    .frame(width: 6, height: 6)
            }
        }
    }
    
}
