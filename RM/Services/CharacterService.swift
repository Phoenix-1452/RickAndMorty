//
//  NetworkingManager.swift
//  RM
//
//  Created by Vlad Sadovodov on 07.07.2024.
//

import Foundation
import Combine

enum NetworkingError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

protocol NetworkManaging {
    func fetchData<T: Decodable>(from urlString: String, type: T.Type) -> AnyPublisher<T, NetworkingError>
}

final class NetworkingManager: NetworkManaging {
//    static let shared = NetworkingManager()
//    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String, type: T.Type) -> AnyPublisher<T, NetworkingError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkingError.requestFailed($0) }
            .flatMap { output -> AnyPublisher<T, NetworkingError> in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    return Fail(error: NetworkingError.invalidResponse).eraseToAnyPublisher()
                }
                return Just(output.data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { NetworkingError.decodingFailed($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}



