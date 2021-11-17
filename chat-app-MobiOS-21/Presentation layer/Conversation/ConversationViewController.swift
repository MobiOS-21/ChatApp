//
//  ConversationViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationViewController: UIViewController {
    // MARK: - Properties
    private let channelId: String
    private let coreDataMessageService: CoreDataMessageServiceProtocol
    private let firestoreService: FireStoreServiceProtocol
    private let gcdService: ProfileDataServiceProtocol
    // MARK: Lazy Stored Properties
    private lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
        let fetchRequest = DBMessage.fetchRequest()
        let sort1 = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", channelId)
        fetchRequest.sortDescriptors = [sort1]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 20
        fetchRequest.fetchLimit = 20
        
        let fetchedRequestController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataMessageService.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedRequestController.delegate = self
        return fetchedRequestController
    }()
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let messageInputView = MessageInputView()
    
    private var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    init(channelId: String,
         coreDataMessageService: CoreDataMessageServiceProtocol,
         firestoreService: FireStoreServiceProtocol,
         gcdService: ProfileDataServiceProtocol) {
        self.channelId = channelId
        self.coreDataMessageService = coreDataMessageService
        self.firestoreService = firestoreService
        self.gcdService = gcdService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcdService.readData { _ in }
        configureUI()
        configureGestures()
        fetchCoreData()
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
        tableView.contentOffset = .zero
        
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
    
    private func fetchCoreData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func fetchChanelMessages() {
        firestoreService.fetchMessages(channelId: channelId) {[weak self] message, action  in
            guard let self = self else { return }
            self.coreDataMessageService.performMessageAction(message: message, channelId: self.channelId, actionType: action)
        }
    }
    
    private func updateTableView() {
        guard let messageCount = fetchedResultsController.fetchedObjects?.count, messageCount > 0 else { return }
        DispatchQueue.main.async {[weak self] in
            self?.tableView.scrollToRow(at: IndexPath(row: messageCount - 1, section: 0), at: .bottom, animated: true)
        }
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
        firestoreService.createMessage(channelId: channelId, message: message, senderName: gcdService.currentProfile?.userName ?? "No name")
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableCell.reuseIdentifier, for: indexPath) as? ConversationTableCell else { fatalError()}
        let message = fetchedResultsController.object(at: indexPath)
        cell.configureCell(with: message)
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        
        self.updateTableView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .none)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.insertRows(at: [newIndexPath], with: .none)
        case .update:
            guard let indexPath = indexPath else { return }
            if let cell = tableView.cellForRow(at: indexPath) as? ConversationsTableCell {
                guard let channel = controller.object(at: indexPath) as? DBChannel else { return }
                cell.configureCell(with: channel)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .none)
        default:
            print("switch type is default")
        }
    }
}
