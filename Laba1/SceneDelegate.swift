//
//  SceneDelegate.swift
//  LAB1
//
//  Created by Zayata Budaeva on 19.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appDependencies: AppDependencyContainer!
    var coordinator: MainCoordinator!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationViewController = UINavigationController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()

        let dependencies = AppDependencyContainer()
        let coordinator = MainCoordinator(
            navigationController: navigationViewController,
            dependencies: dependencies
        )

        self.window = window
        self.appDependencies = dependencies
        self.coordinator = coordinator

        coordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func restartApp() {
        guard let windowScene = window?.windowScene else { return }

        let navController = UINavigationController()
        let newCoordinator = MainCoordinator(navigationController: navController, dependencies: appDependencies)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        self.coordinator = newCoordinator
        newCoordinator.start()
    }
}
