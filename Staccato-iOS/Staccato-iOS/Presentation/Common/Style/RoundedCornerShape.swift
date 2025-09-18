//
//  RoundedCornerShape.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/6/25.
//

import SwiftUI

struct RoundedCornerShape: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
    
}
