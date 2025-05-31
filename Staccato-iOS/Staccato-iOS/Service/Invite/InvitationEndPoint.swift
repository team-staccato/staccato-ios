//
//  InvitationEndPoint.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Alamofire

enum InvitationEndPoint {
    case postInvitations(_ categoryId: Int64, _ membersId: [Int64])
    case getReceivedInvites
    case getSentInvites
    case acceptInvite(_ invitationId: Int64)
    case rejectInvite(_ invitationId: Int64)
    case cancelInvite(_ invitationId: Int64)
}

extension InvitationEndPoint: APIEndpoint {

    var path: String {
        switch self {
        case .postInvitations:
            return "/invitations"
        case .getReceivedInvites:
            return "/invitations/received"
        case .getSentInvites:
            return "/invitations/sent"
        case .acceptInvite(let invitationId):
            return "/invitations/\(invitationId)/accept"
        case .rejectInvite(let invitationId):
            return "/invitations/\(invitationId)/reject"
        case .cancelInvite(let invitationId):
            return "/invitations/\(invitationId)/cancel"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getReceivedInvites, .getSentInvites:
            return .get
        case .postInvitations, .acceptInvite, .rejectInvite, .cancelInvite:
            return .post
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postInvitations:
            return JSONEncoding.default
        case .getReceivedInvites, .getSentInvites:
            return URLEncoding.default
        case .acceptInvite, .rejectInvite, .cancelInvite:
            return URLEncoding.queryString
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .postInvitations(let categoryId, let membersId):
            return PostInvitationsRequest(categoryId: categoryId, inviteeIds: membersId).toDictionary()
        case .getReceivedInvites, .getSentInvites,
                .acceptInvite, .rejectInvite, .cancelInvite:
            return nil
        }
    }

    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
