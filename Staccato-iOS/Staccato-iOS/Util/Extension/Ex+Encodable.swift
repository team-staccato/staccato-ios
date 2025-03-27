//
//  Ex+Encodable.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/24/25.
//

import Foundation

extension Encodable {
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return json
    }
    
}
