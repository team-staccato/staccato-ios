//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

final class STService {

    static let shared = STService()

    private init() { }


    // MARK: - Services

    lazy var categoryService = CategoryService()

    lazy var staccatoService = StaccatoService()

    lazy var commentService = CommentService()
    
    lazy var imageService = ImageService()

}
