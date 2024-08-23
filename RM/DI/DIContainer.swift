//
//  DIContainer.swift
//  RM
//
//  Created by Vlad Sadovodov on 14.08.2024.
//

import Foundation

class DIContainer {
    private var services: [String: Any] = [:]
    
    func register<Service>(_ serviceType: Service.Type, factory: @escaping () -> Service) {
        let key = String(describing: serviceType)
        services[key] = factory
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        let key = String(describing: serviceType)
        guard let factory = services[key] as? () -> Service else {
            fatalError("No registered factory for \(key)")
        }
        return factory()
    }
}
