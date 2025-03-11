//
//  StaccatoService.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/11/25.
//

import Foundation

protocol StaccatoServiceProtocol {
    
    func getStaccatoList(completion: @escaping (GetStaccatoListResponse) -> Void)
    
}

class StaccatoService: StaccatoServiceProtocol {
    
    func getStaccatoList(completion: @escaping (GetStaccatoListResponse) -> Void) {
        NetworkService.shared.request(
            endpoint: StaccatoEndpoint.getStaccatoList,
            responseType: GetStaccatoListResponse.self
        ) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("😢 getStaccatoList 실패 - \(error)")
            }
        }
    }
    
}
