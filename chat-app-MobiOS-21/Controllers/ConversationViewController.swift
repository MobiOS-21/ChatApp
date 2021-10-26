//
//  ConversationViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit
import FirebaseFirestore

class ConversationViewController: UIViewController {
    private var messages: [Message] = []
    private let channel: Channel
    
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        return db.collection("channels").document(channel.identifier).collection("messages")
    }()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchChanelMessages()
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
    
    private func fetchChanelMessages() {
        reference.addSnapshotListener {[weak self] querySnapshot, error in
            guard let self = self,
                  let snapshot = querySnapshot else {
                      print("Error fetching documents: \(String(describing: error))")
                      return
                  }
            
            snapshot.documentChanges.forEach { diff in
                guard let content = diff.document["content"] as? String else {
                    fatalError()
                }
                guard let createdTimestamp = diff.document["created"] as? Timestamp else {
                    fatalError()
                }
                var senderId: String = ""
                /// сделал так потому что кто-то кидает senderID, а кто-то senderId
                if let senderID = diff.document["senderID"] as? String {
                    senderId = senderID
                } else if let senderID = diff.document["senderID"] as? String {
                    senderId = senderID
                }
                guard let senderName = diff.document["senderName"] as? String else {
                    fatalError()
                }
                let message = Message(content: content,
                                      created: Date(timeIntervalSince1970: TimeInterval(createdTimestamp.seconds)),
                                                     senderId: senderId,
                                                     senderName: senderName)
                switch diff.type {
                case .added:
                    self.messages.append(message)
                case .modified:
                    if let index = self.messages.firstIndex(where: { $0.senderId == senderId && $0.created == message.created }) {
                        self.messages[index] = message
                    }
                case .removed:
                    self.messages.removeAll(where: { $0.senderId == senderId && $0.created == message.created })
                }
            }
            self.updateTableView()
        }
    }
    
    private func updateTableView() {
        messages.sort(by: { $0.created < $1.created })
        tableView.reloadData()
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
