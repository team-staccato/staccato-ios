//
//  CategoryModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryModel: Identifiable {
    
    let id: Int64
    
    let thumbNailURL: String?
    
    let title: String
    
    let startAt: String?
    
    let endAt: String?
    
}
