//
//  NetworkService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // MARK: - Response 있는 경우
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type?
    ) async throws -> T? {
        let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
        let urlString = baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let method = endpoint.method
        let parameters = endpoint.parameters
        let encoding = endpoint.encoding
        let headers = HTTPHeaders(endpoint.headers ?? [:])
        
        let response = await AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self)
        .response
        
        
#if DEBUG
        print("-------------------Response-------------------\n▫️\(method.rawValue) \(url) parameters: \(String(describing: parameters)) \n▫️statusCode: \(response.response?.statusCode ?? 0) \n▫️response: \(response) \n-----------------------------------------------")
#endif
        
        // status code가 200~299가 아닌 경우 정해져 있는 에러를 뱉도록 수정
        if let urlResponse = response.response, !(200...299).contains(urlResponse.statusCode) {
            print(response.data ?? "")
            throw ErrorHandler.handleError(urlResponse, response.data)
        }
        
        return response.value
    }
    
    
    // MARK: - Response 없는 경우
    
    func request(
        endpoint: APIEndpoint
    ) async throws {
        let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
        let urlString = baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let method = endpoint.method
        let parameters = endpoint.parameters
        let encoding = endpoint.encoding
        let headers = HTTPHeaders(endpoint.headers ?? [:])
        
        let response = await AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .serializingData()
        .response
        
        #if DEBUG
        print("-------------------Response-------------------\n▫️\(method.rawValue) \(url) parameters: \(String(describing: parameters)) \n▫️statusCode: \(response.response?.statusCode ?? 0) \n-----------------------------------------------")
        #endif
        
        if let urlResponse = response.response, !(200...299).contains(urlResponse.statusCode) {
            throw ErrorHandler.handleError(urlResponse, response.data)
        }
    }
    
}


protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
