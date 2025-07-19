//
//  PushNotificationType.swift
//  Staccato-iOS
//
//  Created by 김영현 on 7/15/25.
//

import Foundation

enum PushNotificationType: String {
    case receiveInvitation = "RECEIVE_INVITATION"
    case acceptInvitation = "ACCEPT_INVITATION"
    case createStaccato = "STACCATO_CREATED"
    case createComment = "COMMENT_CREATED"
}
