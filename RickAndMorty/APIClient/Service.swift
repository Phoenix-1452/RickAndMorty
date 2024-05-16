//
//  Service.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import Foundation

/// Primaty API service object to get Rick and Morty data
final class Service {
    
    /// Shared singleton instance
    static let shared = Service()
    
    /// Private init
    private init() {}
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data error 
    public func execute(_ request: Request, completion: @escaping () -> Void) {
        
    }
    
}
