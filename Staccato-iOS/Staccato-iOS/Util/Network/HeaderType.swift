//
//  HeaderType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum HeaderType {
    
    static let noHeader: [String:String] = [:]
    
    static func token() -> [String: String] {
        if let token = AuthTokenManager.shared.getToken() {
            return ["Authorization" : token]
        } else {
            return noHeader
        }
    }
    
}
