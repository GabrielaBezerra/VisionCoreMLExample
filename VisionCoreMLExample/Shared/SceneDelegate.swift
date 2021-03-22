//
//  SceneDelegate.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 12/01/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Initializing ML Model & its Manager
    let manager: ModelManager = ModelManager.load(.yolov3Tiny)

    // MARK: - Creating Root Navigation Controller
    lazy var rootNavigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: OptionsViewController(manager))
        controller.navigationBar.prefersLargeTitles = true
        controller.isNavigationBarHidden = true
        return controller
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootNavigationController
            self.window = window
            window.makeKeyAndVisible()
        }

        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
    }

}
