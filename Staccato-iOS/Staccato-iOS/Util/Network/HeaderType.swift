//
//  HeaderType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum HeaderType {
    
    static let noHeader: [String:String] = [:]
    
    static let basicHeader: [String:String] = ["Content-Type": "application/json"]
    
    static func tokenOnly() -> [String:String] {
        if let token = AuthTokenManager.shared.getToken() {
            return ["Authorization" : token]
        } else {
            return noHeader
        }
    }
    
    static func headerWithToken() -> [String:String] {
        if let token = AuthTokenManager.shared.getToken() {
            return ["Content-Type" : "application/json", "Authorization" : token]
        } else {
            return basicHeader
        }
    }
    
}
