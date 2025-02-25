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
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
        let urlString = baseURL + endpoint.path
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let method = HTTPMethod(rawValue: endpoint.method)
        let parameters = endpoint.parameters
        let headers = HTTPHeaders(endpoint.headers ?? [:])
        
        AF.request(
            url, method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("❌ 상태 코드: \(response.response?.statusCode ?? 0)")
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        print("❌ 네트워크 요청 실패: \(errorResponse.message)")
                    } catch {
                        print("❌ 알 수 없는 오류: \(error.localizedDescription)")
                    }
                } else {
                    print("❌ 알 수 없는 오류: \(error.localizedDescription)")
                }
                completion(.failure(.requestFailed))
            }
        }
    }
}

protocol APIEndpoint {
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
