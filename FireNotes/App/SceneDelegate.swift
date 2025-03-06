//
//  SceneDelegate.swift
//  FireNotes
//
//  Created by Pavel Lakhno on 06.03.2025.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseApp.configure()
//        let viewController = ViewController()

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navController = UINavigationController(rootViewController: NotesViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }



}

