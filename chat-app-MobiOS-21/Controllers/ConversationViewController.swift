//
//  ConversationViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit
import FirebaseFirestore

class ConversationViewController: UIViewController {
    // MARK: - Properties
    private var messages: [Message] = []
    private let channel: Channel
    // MARK: - Firestore
    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        return db.collection("channels").document(channel.identifier).collection("messages")
    }()
    
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let messageInputView = MessageInputView()
    
    private var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
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
        configureGestures()
        fetchChanelMessages()
    }
    
    // MARK: - Private
    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(messageInputView)
        
        messageInputView.sendButtonCallback = sendMessage(message:)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ConversationTableCell.self, forCellReuseIdentifier: ConversationTableCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            messageInputView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            messageInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 80),
            messageInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        bottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
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
                guard var senderName = diff.document["senderName"] as? String else {
                    fatalError()
                }
                if senderName.isEmpty { senderName = "No name" }
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
        guard messages.count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
    }

    private func configureGestures() {
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func sendMessage(message: String) {
        let message = Message(content: message, created: Date())
        self.reference.addDocument(data: message.toDict)
    }
    
    // MARK: - Objc
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomConstraint?.constant = -keyboardHeight
            tableView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        bottomConstraint?.constant = 0
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
