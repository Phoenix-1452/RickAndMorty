//
//  SceneDelegate.swift
//  RM
//
//  Created by Vlad Sadovodov on 06.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
    }
}
