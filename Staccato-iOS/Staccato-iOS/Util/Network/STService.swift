//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

class STService {

    static let shared = STService()

    init() { }


    // MARK: - Services

    lazy var categoryService = CategoryService()

    lazy var staccatoService = StaccatoService()

    lazy var myPageService = MyPageService()

    lazy var commentService = CommentService()

}
