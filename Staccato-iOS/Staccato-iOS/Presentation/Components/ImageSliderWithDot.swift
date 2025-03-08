//
//  ImageSliderWithDot.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import SwiftUI

struct ImageSliderWithDot: View {
    
    // MARK: - Properties
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    private let images: [Image]
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let minimumDragDistance: CGFloat = 50
    
    init(images: [Image], imageWidth: CGFloat, imageHeight: CGFloat) {
        self.images = images
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
            ForEach(images.indices, id: \.self) { index in
                images[index]
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
            }
        }
        .frame(width: imageWidth, alignment: .leading)
        .offset(x: -CGFloat(currentIndex) * imageWidth + offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation.width
                }
                .onEnded { value in
                    let dragAmount = value.translation.width
                    // 왼쪽으로 스와이프
                    if dragAmount < -minimumDragDistance && currentIndex < images.count - 1 {
                        withAnimation {
                            currentIndex += 1
                        }
                    }
                    // 오른쪽으로 스와이프
                    if dragAmount > minimumDragDistance && currentIndex > 0 {
                        withAnimation {
                            currentIndex -= 1
                        }
                    }
                    // 오프셋 초기화
                    withAnimation {
                        offset = 0
                    }
                }
        )
    }
    
    var dotCarousel: some View {
        HStack(spacing: 5) {
            ForEach(0..<images.count, id: \.self) { index in
                Circle()
                    .fill(currentIndex == index ? .gray3 : .gray2)
                    .frame(width: 6, height: 6)
            }
        }
    }
    
}


// MARK: - Preview

#Preview {
    ImageSliderWithDot(
        images: StaccatoDetailModel.sample.momentImages,
        imageWidth: ScreenUtils.width,
        imageHeight: ScreenUtils.width
    )
}
