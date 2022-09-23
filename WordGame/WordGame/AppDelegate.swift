//
//  AppDelegate.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        // TODO: Remove to container
        let viewModel = WordGameViewModel(wordGameRepo: FileManagerHandler())
        let rootViewController = WordGameViewController(viewModel: viewModel)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    
        return true
    }
}
