//
//  InvitationEndPoint.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Alamofire

enum InvitationEndPoint {
    case getSearchMemberList(_ name: String)
    case postInvitations(_ categoryId: Int64, _ membersId: [Int64])
}

extension InvitationEndPoint: APIEndpoint {

    var path: String {
        switch self {
        case .getSearchMemberList:
            return "/members/search"
        case .postInvitations:
            return "/invitations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getSearchMemberList: return .get
        case .postInvitations: return .post
        }
    }

    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getSearchMemberList:
            return URLEncoding.queryString
        case .postInvitations:
            return JSONEncoding.default
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getSearchMemberList(let name):
            return ["nickname": name]
        case .postInvitations(let categoryId, let membersId):
            return PostInvitationsRequest(categoryId: categoryId, inviteeIds: membersId).toDictionary()
        }
    }

    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
