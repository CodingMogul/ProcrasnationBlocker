import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            // Check if onboarding is complete
            let onboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
            
            // Set the initial view
            if onboardingComplete {
                window.rootViewController = UIHostingController(rootView: MainTabView())
            } else {
                window.rootViewController = UIHostingController(rootView: OnboardingView())
            }

            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
