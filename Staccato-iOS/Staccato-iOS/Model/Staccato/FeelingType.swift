//
//  FeelingType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

enum FeelingType: CaseIterable, Identifiable {
    
    case excited, angry, happy, scared, sad
    
    static let nothing: String = "nothing"
    
    var id: Int {
        switch self {
        case .excited: return 0
        case .angry: return 1
        case .happy: return 2
        case .scared: return 3
        case .sad: return 4
        }
    }
    
    var serverKey: String {
        switch self {
        case .excited: return "excited"
        case .angry: return "angry"
        case .happy: return "happy"
        case .scared: return "scared"
        case .sad: return "sad"
        }
    }
    
    var colorImage: Image {
        switch self {
        case .excited: return Image(.feelingExcited)
        case .angry: return Image(.feelingAngry)
        case .happy: return Image(.feelingHappy)
        case .scared: return Image(.feelingScared)
        case .sad: return Image(.feelingSad)
        }
    }
    
    var grayImage: Image {
        switch self {
        case .excited: return Image(.feelingExcitedGray)
        case .angry: return Image(.feelingAngryGray)
        case .happy: return Image(.feelingHappyGray)
        case .scared: return Image(.feelingScaredGray)
        case .sad: return Image(.feelingSadGray)
        }
    }
    
}


// MARK: - String to FeelingType

extension FeelingType {
    
    private static let serverKeyMap: [String : FeelingType] = {
        var map = [String : FeelingType]()
        for feeling in FeelingType.allCases {
            map[feeling.serverKey] = feeling
        }
        return map
    }()
    
    static func from(serverKey: String) -> FeelingType? {
        return serverKeyMap[serverKey]
    }
    
}
