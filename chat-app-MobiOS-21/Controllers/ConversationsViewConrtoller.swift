//
//  ConversationsViewConrtoller.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.10.2021.
//

import UIKit

class ConversationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let mockArray: [[ConversationsModel]] = [
        [
            ConversationsModel(name: "Ronald Robertson", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date(), online: true, hasUnreadMessages: true),
            ConversationsModel(name: "Ronald Robertson Ronald Robertson Ronald Robertson Ronald Robertson",
                               message: "test message", date: Date(timeIntervalSince1970: 151351519), online: true, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson", message: "message",
                               date: Date(timeIntervalSince1970: 21125515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson 2", message: "test message",
                               date: nil, online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Arthur Bell", message: nil,
                               date: Date(timeIntervalSince1970: 21216515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Alex Dergilev", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                               date: Date(timeIntervalSince1970: 211225515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Oleg sinev", message: "something message",
                               date: Date(timeIntervalSince1970: 211255515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson", message: nil,
                               date: Date(timeIntervalSince1970: 211125515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: nil, message: nil,
                               date: Date(timeIntervalSince1970: 2112325515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "test", message: "test", date: Date(), online: false, hasUnreadMessages: true)
        ],
        [
            ConversationsModel(name: "Ronald Robertson", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                               date: Date(), online: true, hasUnreadMessages: true),
            ConversationsModel(name: "Ronald Robertson Ronald Robertson Ronald Robertson Ronald Robertson",
                               message: "test message", date: Date(timeIntervalSince1970: 151351519), online: true, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson", message: "message",
                               date: Date(timeIntervalSince1970: 21125515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson 2", message: "test message",
                               date: nil, online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Arthur Bell", message: nil,
                               date: Date(timeIntervalSince1970: 21216515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Alex Dergilev", message: nil,
                               date: Date(timeIntervalSince1970: 211225515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Oleg sinev", message: "something message",
                               date: Date(timeIntervalSince1970: 211255515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "Johnny Watson", message: nil,
                               date: Date(timeIntervalSince1970: 211125515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: nil, message: nil,
                               date: Date(timeIntervalSince1970: 2112325515), online: false, hasUnreadMessages: false),
            ConversationsModel(name: "test", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date(), online: false, hasUnreadMessages: true)
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Private
    private func configureUI() {
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func logThemeChanging(selectedTheme: UIColor) {
        debugPrint("Theme is \(String(describing: selectedTheme))")
        save(selectedTheme: selectedTheme)
    }
    
    private func save(selectedTheme: UIColor) {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.setColor(color: selectedTheme, forKey: UserDefaults.UDKeys.selectedTheme.rawValue)
        }
    }
    
    private func showAlertForThemesVC() {
        let showThemesSwiftVC: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVCSwift")
            (vc as? ThemesViewControllerSwift)?.didSelectThemeClosure = self.logThemeChanging(selectedTheme:)
            self.present(vc, animated: true)
        }
        
        let showThemesObjcVC: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Conversations", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ThemesVC")
            (vc as? ThemesViewController)?.delegate = self
            self.present(vc, animated: true)
        }
        self.openAlert(message: "Select themes view controller type",
                       actionTitles: ["ThemesVC Swift", "Themes VC Objective-c"],
                       actionStyles: [.default, .default],
                       actions: [showThemesSwiftVC, showThemesObjcVC])
    }
    //MARK: - IBActions
    @IBAction func tapProfileBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(vc, animated: true)
    }
    
    @IBAction func tapThemesBtn(_ sender: Any) {
        showAlertForThemesVC()
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mockArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableCell.reuseIdentifire, for: indexPath) as? ConversationsTableCell else { fatalError() }
        
        cell.configureCell(with: mockArray[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online": "History"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatName = mockArray[indexPath.section][indexPath.row].name
        let vc = ConversationViewController()
        vc.title = chatName
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}
