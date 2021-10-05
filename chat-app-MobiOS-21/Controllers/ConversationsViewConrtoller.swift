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
    
    private func configureUI() {
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
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
