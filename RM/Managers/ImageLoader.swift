//
//  ImageLoader.swift
//  RM
//
//  Created by Vlad Sadovodov on 26.07.2024.
//

import Foundation

final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}
    
    private var imageDataCache = NSCache<NSString, NSData>()

    
    func loadImage(_ url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self]  data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.badURL))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
