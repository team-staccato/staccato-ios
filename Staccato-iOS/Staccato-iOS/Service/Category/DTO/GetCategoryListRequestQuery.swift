//
//  GetCategoryListRequest.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

struct GetCategoryListRequestQuery: Encodable {
    
    let filters: String?
    
    let sort: String?
    
    enum CodingKeys: CodingKey {
        case filters
        case sort
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.filters, forKey: .filters)
        try container.encodeIfPresent(self.sort, forKey: .sort)
    }
    
}
