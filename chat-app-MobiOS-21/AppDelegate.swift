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
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let color = UserDefaults.standard.colorForKey(key: UserDefaults.UDKeys.selectedTheme.rawValue) {
            UINavigationBar.appearance().backgroundColor = color
        }

        DispatchQueue.main.async { [weak self] in
            self?.rootAssembly.coreAssembly.coreDataStack.printSQLiteDB()
        }
        
        FirebaseApp.configure()
        
        let controller = rootAssembly.presentationAssembly.conversationsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        window = UIWindow()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        return true
    }
}
