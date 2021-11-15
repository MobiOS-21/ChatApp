//
//  PresentationAssembly.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

import UIKit

protocol PresentationAssemblyProtocol {
    func conversationsViewController() -> ConversationsViewController
    func conversationViewController(channelId: String) -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func swiftThemesViewController() -> ThemesViewControllerSwift
    func objcThemesViewController() -> ThemesViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationsViewController() -> ConversationsViewController {
        let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ConversationsVC") as? ConversationsViewController else { fatalError()}
        return vc
    }
    
    func conversationViewController(channelId: String) -> ConversationViewController {
        let vc = ConversationViewController(channelId: channelId, dbChannelId: channelId)
        return vc
    }
    
    func profileViewController() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController else { fatalError()}
        return vc
    }
    
    func swiftThemesViewController() -> ThemesViewControllerSwift {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVCSwift") as? ThemesViewControllerSwift else { fatalError()}
        return vc
    }
    
    func objcThemesViewController() -> ThemesViewController {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVC") as? ThemesViewController else { fatalError() }
        return vc
    }
}
