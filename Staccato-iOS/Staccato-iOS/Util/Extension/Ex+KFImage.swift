//
//  Ex+KFImage.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/24/25.
//
import Foundation
import SwiftUI
import Kingfisher

extension KFImage {
    func fillPersonImage(width: CGFloat, height: CGFloat) -> some View {
        self.placeholder {
            Image(.personCircleFill)
                .resizable()
                .foregroundStyle(.gray2)
                .frame(width: width, height: height)
        }
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: width, height: height)
        .clipShape(Circle())
    }
}
