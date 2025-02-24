//
//  FeelingType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

enum FeelingType: CaseIterable, Identifiable {
    
    case excited, angry, happy, scared, sad
    
    var id: String {
        return serverKey
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
    
    var image: Image {
        switch self {
        case .excited: return Image("feeling_excited")
        case .angry: return Image("feeling_angry")
        case .happy: return Image("feeling_happy")
        case .scared: return Image("feeling_scared")
        case .sad: return Image("feeling_sad")
        }
    }
    
}
