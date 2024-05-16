//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 16.05.2024.
//

import Foundation

/// Represents unique API enpoints
@frozen enum Endpoint: String {
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
