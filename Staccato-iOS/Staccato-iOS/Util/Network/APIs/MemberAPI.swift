//
//  Member .swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/15/25.
//

import Foundation

enum MemberAPI: APIEndpoint {

    var path: String {
        switch self {
        }
    }

    var method: String {
        switch self {
        }
    }

    var parameters: [String: Any]? {
        switch self {
        }
    }
    
    var headers: [String: String]? {
           switch self {
           default:
               return [
                   "Authorization": "Bearer YOUR_ACCESS_TOKEN",
                   "Content-Type": "application/json"
               ]
           }
    }
}
