//
//  SceneDelegate.swift
//  FriendsCard
//
//  Created by Shalin on 8/26/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

//        // Create the SwiftUI view that provides the window contents.
//        let contentView = ContentView()
//
//        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
        
        let googleDelegate = (UIApplication.shared.delegate as! AppDelegate).googleDelegate
        
        // Add googleDelegate as an environment object
        let contentView = RootView().environmentObject(googleDelegate)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            GIDSignIn.sharedInstance().presentingViewController = window.rootViewController
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Get the googleDelegate from AppDelegate
//        let googleDelegate = (UIApplication.shared.delegate as! AppDelegate).googleDelegate
//        
//        if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
//            // Add googleDelegate as an environment object
//            let contentView = PhoneNumberView().environmentObject(googleDelegate)
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                window.rootViewController = UIHostingController(rootView: contentView)
//                GIDSignIn.sharedInstance().presentingViewController = window.rootViewController
//                self.window = window
//                window.makeKeyAndVisible()
//            }
//        } else {
//            // Add googleDelegate as an environment object
//            let contentView = HomeView().environmentObject(googleDelegate)
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                window.rootViewController = UIHostingController(rootView: contentView)
//                GIDSignIn.sharedInstance().presentingViewController = window.rootViewController
//                self.window = window
//                window.makeKeyAndVisible()
//            }
//        }
        
//        print(UserDefaults.standard.bool(forKey: "onboardingComplete"))
//
//            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//            self.store.fetchContacts()
//
//            let contentView = HomeView(store: store)
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                window.rootViewController = UIHostingController(rootView: contentView)
//                self.window = window
//                window.makeKeyAndVisible()
//            }
//        } else {
//            // Get the googleDelegate from AppDelegate
//            let googleDelegate = (UIApplication.shared.delegate as! AppDelegate).googleDelegate
//
//            // Add googleDelegate as an environment object
//            let contentView = WelcomeView().environmentObject(googleDelegate)
//
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                window.rootViewController = UIHostingController(rootView: contentView)
//
//                // Set presentingViewControll to rootViewController
//                GIDSignIn.sharedInstance().presentingViewController = window.rootViewController
//
//                self.window = window
//                window.makeKeyAndVisible()
//            }
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

