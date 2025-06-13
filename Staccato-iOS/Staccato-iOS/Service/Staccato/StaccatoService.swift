//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

protocol StaccatoServiceProtocol {

    func getStaccatoList() async throws -> GetStaccatoListResponse
    func getStaccatoDetail(_ staccatoId: Int64) async throws -> GetStaccatoDetailResponse

    func postStaccato(_ requestBody: PostStaccatoRequest) async throws -> Void
    func postStaccatoFeeling(_ staccatoId: Int64,
                             requestBody: PostStaccatoFeelingRequest) async throws -> Void
    func postShareLink(_ staccatoId: Int64) async throws -> PostShareLinkResponse
    
    func putStaccato(_ staccatoId: Int64,
                        requestBody: PutStaccatoRequest) async throws -> Void

    func deleteStaccato(_ staccatoId: Int64) async throws

}

class StaccatoService: StaccatoServiceProtocol {

    // MARK: - GET

    func getStaccatoList() async throws -> GetStaccatoListResponse {
        guard let staccatoList = try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.getStaccatoList,
            responseType: GetStaccatoListResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return staccatoList
    }

    func getStaccatoDetail(_ staccatoId: Int64) async throws -> GetStaccatoDetailResponse {
        guard let staccatoDetail = try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.getStaccatoDetail(staccatoId),
            responseType: GetStaccatoDetailResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }
        
        return staccatoDetail
    }


    // MARK: - POST

    func postStaccato(_ requestBody: PostStaccatoRequest) async throws {
        try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.postStaccato(requestBody: requestBody)
        )
    }

    func postStaccatoFeeling(_ staccatoId: Int64,
                             requestBody: PostStaccatoFeelingRequest) async throws -> Void {
        try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.postStaccatoFeeling(staccatoId, requestBody: requestBody)
        )
    }

    func postShareLink(_ staccatoId: Int64) async throws -> PostShareLinkResponse {
        guard let shareLink = try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.postShareLink(staccatoId),
            responseType: PostShareLinkResponse.self
        ) else {
            throw StaccatoError.optionalBindingFailed
        }

        return shareLink
    }


    // MARK: - PUT

    func putStaccato(_ staccatoId: Int64, requestBody: PutStaccatoRequest) async throws {
        try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.putStaccato(staccatoId, requestBody: requestBody)
        )
    }

    // MARK: - DELETE

    func deleteStaccato(_ staccatoId: Int64) async throws {
        try await NetworkService.shared.request(
            endpoint: StaccatoEndpoint.delteStaccato(staccatoId)
        )
    }

}
