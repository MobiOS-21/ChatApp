//
//  ConversationViewController.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

protocol ConversationProtocol: AnyObject {
    func sendImage(url: URL)
}

class ConversationViewController: UIViewController {
    // MARK: - Properties
    private let channelId: String
    private let messageViewModel: MessageViewModelProtocol
    weak var delegate: ConversationProtocol?
    private let presentationService: PresentationAssemblyProtocol
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private lazy var messageInputView = MessageInputView(parentVC: self)
    
    private var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    init(channelId: String, messageViewModel: MessageViewModelProtocol, presentationService: PresentationAssemblyProtocol) {
        self.presentationService = presentationService
        self.channelId = channelId
        self.messageViewModel = messageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureGestures()
        fetchCoreData()
        messageViewModel.fetchMessages()
    }
    
    // MARK: - Private
    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(messageInputView)
        
        messageInputView.sendButtonCallback = messageViewModel.sendMessage(message:)
        messageInputView.imageBtnCallback = openPhotosVC
        
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
            try messageViewModel.fetchedResultsController.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func updateTableView() {
        guard let messageCount = messageViewModel.fetchedResultsController.fetchedObjects?.count, messageCount > 0 else { return }
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
    
    private func openPhotosVC() {
        let vc = presentationService.photosViewController()
        vc.selectImageCallback = {[weak self] url in
            guard let self = self else { return }
            self.delegate?.sendImage(url: url)
        }
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true, completion: nil)
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
        return messageViewModel.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableCell.reuseIdentifier, for: indexPath) as? ConversationTableCell else { fatalError()}
        let message = messageViewModel.fetchedResultsController.object(at: indexPath)
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
