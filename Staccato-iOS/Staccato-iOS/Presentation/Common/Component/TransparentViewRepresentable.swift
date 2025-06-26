//
//  TransparentViewRepresentable.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/15/25.
//

import SwiftUI

// MARK: - UIKit bridge to ensure transparent background

struct TransparentViewRepresentable: UIViewRepresentable {
    
    let backgroundColor: UIColor
    
    init(_ backgroundColor: UIColor = .clear) {
        self.backgroundColor = backgroundColor
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = backgroundColor
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
