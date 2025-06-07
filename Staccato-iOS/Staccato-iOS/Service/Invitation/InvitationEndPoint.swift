//
//  InvitationEndPoint.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Alamofire

enum InvitationEndPoint {
    case postInvitations(_ categoryId: Int64, _ membersId: [Int64])
    case getReceivedInvitations
    case getSentInvitations
    case postAcceptInvitation(_ invitationId: Int64)
    case postRejectInvitation(_ invitationId: Int64)
    case postCancelInvitation(_ invitationId: Int64)
}

extension InvitationEndPoint: APIEndpoint {

    var path: String {
        switch self {
        case .postInvitations:
            return "/invitations"
        case .getReceivedInvitations:
            return "/invitations/received"
        case .getSentInvitations:
            return "/invitations/sent"
        case .postAcceptInvitation(let invitationId):
            return "/invitations/\(invitationId)/accept"
        case .postRejectInvitation(let invitationId):
            return "/invitations/\(invitationId)/reject"
        case .postCancelInvitation(let invitationId):
            return "/invitations/\(invitationId)/cancel"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getReceivedInvitations, .getSentInvitations:
            return .get
        case .postInvitations, .postAcceptInvitation, .postRejectInvitation, .postCancelInvitation:
            return .post
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postInvitations:
            return JSONEncoding.default
        case .getReceivedInvitations, .getSentInvitations:
            return URLEncoding.default
        case .postAcceptInvitation, .postRejectInvitation, .postCancelInvitation:
            return URLEncoding.queryString
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .postInvitations(let categoryId, let membersId):
            return PostInvitationsRequest(categoryId: categoryId, inviteeIds: membersId).toDictionary()
        case .getReceivedInvitations, .getSentInvitations,
                .postAcceptInvitation, .postRejectInvitation, .postCancelInvitation:
            return nil
        }
    }

    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
