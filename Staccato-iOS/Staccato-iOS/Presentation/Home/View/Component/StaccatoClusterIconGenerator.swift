//
//  StaccatoClusterIconGenerator.swift
//  Staccato-iOS
//
//  Created by 김유림 on 7/1/25.
//

import Foundation

import GoogleMapsUtils

class StaccatoClusterIconGenerator: GMUDefaultClusterIconGenerator {

    override func icon(forSize size: UInt) -> UIImage {
        let image: UIImage

        switch size {
        case 0...9:
            image = .imgClusterMint
        case 10...99:
            image = .imgClusterBlue
        default:
            image = .imgClusterPurple
        }

        let text = "\(size)"

        return drawText(text, on: image)
    }

    private func drawText(_ text: String, on image: UIImage) -> UIImage {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold) // TODO: 폰트시스템 재정립 후 수정
        let scale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        defer { UIGraphicsEndImageContext() }

        image.draw(at: .zero)

        let textColor: UIColor = .white
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: style
        ]

        let textSize = text.size(withAttributes: attributes)
        let rect = CGRect(
            x: (image.size.width - textSize.width) / 2,
            y: (image.size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )

        text.draw(in: rect, withAttributes: attributes)
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
    }

}
