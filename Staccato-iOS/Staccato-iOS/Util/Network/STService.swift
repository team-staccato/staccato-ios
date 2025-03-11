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
    
    lazy var categoryServie = CategoryService()
    
    lazy var staccatoService = StaccatoService()
    
}
