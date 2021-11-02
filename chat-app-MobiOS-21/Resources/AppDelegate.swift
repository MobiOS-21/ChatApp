//
//  AppDelegate.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.09.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let color = UserDefaults.standard.colorForKey(key: UserDefaults.UDKeys.selectedTheme.rawValue) {
            UINavigationBar.appearance().backgroundColor = color
        }
        
        GCDDataManager().readData { _ in }
        FirebaseApp.configure()
        return true
    }
}
