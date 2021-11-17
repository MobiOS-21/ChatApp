//
//  ConversationsViewConrtoller.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.10.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var coreDataChannelService: CoreDataChannelServiceProtocol?
    var firestoreService: FireStoreServiceProtocol?
    var presentationService: PresentationAssemblyProtocol?
    // MARK: Lazy Stored Properties
    lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchRequest = DBChannel.fetchRequest()
        let sort1 = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sort2 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 20
        
        guard let coreDataService = coreDataChannelService else {
            fatalError()
        }

        let fetchedRequestController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataService.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedRequestController.delegate = self
        return fetchedRequestController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchCoreData()
        fetchChanellsData()
    }
    
    // MARK: - ConfigureVC Properties
    func setServices(coreDataChannelService: CoreDataChannelServiceProtocol,
                     firestoreService: FireStoreServiceProtocol,
                     presentationService: PresentationAssemblyProtocol) {
        self.coreDataChannelService = coreDataChannelService
        self.firestoreService = firestoreService
        self.presentationService = presentationService
    }
    
    // MARK: - Private
    private func configureUI() {
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchCoreData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    private func fetchChanellsData() {
        firestoreService?.fetchChannels {[weak self] channel, action  in
            guard let self = self else { return }
            self.coreDataChannelService?.performChannelAction(channel: channel, actionType: action)
        }
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
            guard let self = self,
                  let vc = self.presentationService?.swiftThemesViewController()else { return }
            vc.didSelectThemeClosure = self.logThemeChanging(selectedTheme:)
            self.present(vc, animated: true)
        }
        
        let showThemesObjcVC: (UIAlertAction) -> Void = {[weak self] _ in
            guard let self = self,
            let vc = self.presentationService?.objcThemesViewController()else { return }
            vc.delegate = self
            self.present(vc, animated: true)
        }
        self.openAlert(message: "Select themes view controller type",
                       actionTitles: ["ThemesVC Swift", "Themes VC Objective-c"],
                       actionStyles: [.default, .default],
                       actions: [showThemesSwiftVC, showThemesObjcVC])
    }
    
    private func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fetchedResultsController.sections,
            indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }
    // MARK: - IBActions
    @IBAction func tapProfileBtn(_ sender: Any) {
        guard let vc = presentationService?.profileViewController() else { return }
        self.present(vc, animated: true)
    }
    
    @IBAction func tapCreateChannelBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Create channel", message: "Alert Message", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter channel name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: {[weak self] _ in
            guard let self = self, let channelName = alert.textFields?.first?.text  else { return }
            self.firestoreService?.createChannel(channelName: channelName)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapThemesBtn(_ sender: Any) {
        showAlertForThemesVC()
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableCell.reuseIdentifire, for: indexPath) as? ConversationsTableCell else { fatalError() }
        let channel = fetchedResultsController.object(at: indexPath)
        if self.validateIndexPath(indexPath) {
            cell.configureCell(with: channel)
        } else {
            debugPrint("Attempting to configure a cell for an indexPath that is out of bounds: \(indexPath)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController.object(at: indexPath)
        guard let vc = presentationService?.conversationViewController(channelId: channel.identifier ?? "") else { return }
        vc.title = channel.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let channelId = fetchedResultsController.object(at: indexPath).identifier else { return }
            firestoreService?.deleteChannel(channelId: channelId)
            
        }
    }
}

extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            if let cell = tableView.cellForRow(at: indexPath) as? ConversationsTableCell {
                guard let channel = controller.object(at: indexPath) as? DBChannel else { return }
                cell.configureCell(with: channel)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            print("switch type is default")
        }
    }
}
