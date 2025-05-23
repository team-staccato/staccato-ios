//
//  Ex+Image.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI
import Kingfisher

extension Image {
    init(_ icon: StaccatoIcon) {
        self.init(systemName: icon.rawValue)
    }
}

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
