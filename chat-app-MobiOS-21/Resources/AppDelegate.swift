//
//  AppDelegate.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint("application moved from not running to inactive: \(#function)")
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        debugPrint("application will move from not running to inactive: \(#function)")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("application moved from inactive to active: \(#function)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("application moved from active to inactive: \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("application moved from inactive to background \(#function)")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("application moved from background to active: \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("application moved from background to close \(#function)")
    }
}

