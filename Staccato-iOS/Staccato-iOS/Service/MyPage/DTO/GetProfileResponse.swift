//
//  GetProfileResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Foundation

struct GetProfileResponse: Decodable {
    
    let nickname: String
    
    let profileImageUrl: String
    
    let code: String
    
}

