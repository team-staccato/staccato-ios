//
//  MemberService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Foundation

struct MemberService {
    static func getProfile() async throws -> GetProfileResponse {
        guard let profile = try await NetworkService.shared.request(
            endpoint: MemberEndpoint.getProfile,
            responseType: GetProfileResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return profile
    }
    
    static func getSearchMemberList(_ name: String, _ categoryId: Int64) async throws -> SearchMemberResponse {
        guard let memberList = try await NetworkService.shared.request(
            endpoint: MemberEndpoint.getSearchMemberList(name, categoryId),
            responseType: SearchMemberResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        return memberList
    }
}
