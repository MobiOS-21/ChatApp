//
//  ConversationViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    private var messages: [ConversationModel] = [
        ConversationModel(text: "small message", isMyMessage: Bool.random()),
        ConversationModel(text: "multiline message \n message \n message", isMyMessage: Bool.random())
    ]
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateMessages()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ConversationTableCell.self, forCellReuseIdentifier: ConversationTableCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func generateMessages() {
        let numberOfMessages = Int.random(in: 5...100)
        for _ in 0...numberOfMessages {
            messages.append(ConversationModel(text: randomString(length: Int.random(in: 10...500)), isMyMessage: Bool.random()))
        }
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefgh ijklmnopqrstuv wxyzABCDE FGHIJKLMNOPQ RSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableCell.reuseIdentifier, for: indexPath) as? ConversationTableCell else { fatalError()}
        cell.configureCell(with: messages[indexPath.row])
        return cell
    }
}
