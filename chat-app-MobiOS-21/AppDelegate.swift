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
    private lazy var emitterLayer: CAEmitterLayer = {
        guard let image = UIImage(named: "tinkoffLogo") else { return CAEmitterLayer() }
        let layer = rootAssembly.presentationAssembly.animators().getEmmitter(with: image)
        layer.lifetime = 0
        return layer
    }()
    
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
        setupEmitter()
        configureGesture()
        return true
    }
    
    private func setupEmitter() {
        emitterLayer.emitterSize = CGSize(width: 50, height: 50)
        window?.layer.addSublayer(emitterLayer)
    }
    
    private func configureGesture() {
        let gest = UILongPressGestureRecognizer(target: self, action: #selector(longGestureFunc(gesture:)))
        window?.addGestureRecognizer(gest)
    }
    
    @objc private func longGestureFunc(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: window)
        emitterLayer.emitterPosition = CGPoint(x: location.x, y: location.y )
        
        switch gesture.state {
        case .began, .changed:
            emitterLayer.lifetime = 1
        default:
            emitterLayer.lifetime = 0
        }
    }
}
