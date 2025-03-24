//
//  Ex+ Encodable.swift
//  Staccato-iOS
//
//  Created by 정승균 on 3/24/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
