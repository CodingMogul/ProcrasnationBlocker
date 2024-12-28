//
//  SceneDelegate.swift
//  iOS (App)
//
//  Created by Daniel McKenzie on 12/28/24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure we have a valid UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create the SwiftUI view that provides the app's main interface
        let contentView = MainTabView() // Replace with your main SwiftUI view
        
        // Create a UIWindow and set it as the root view
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
}

