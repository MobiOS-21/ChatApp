//
//  MessageViewModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 18.11.2021.
//

import CoreData

protocol MessageViewModelProtocol {
    func fetchMessages()
    func sendMessage(message: String)
    var fetchedResultsController: NSFetchedResultsController<DBMessage> { get }
}

class MessageViewModel: MessageViewModelProtocol {
    // MARK: Lazy Stored Properties
    lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
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
        return fetchedRequestController
    }()
    
    private let coreDataMessageService: CoreDataMessageServiceProtocol
    private let firestoreService: FireStoreServiceProtocol
    private let gcdService: ProfileDataServiceProtocol
    
    private let channelId: String

    init(coreDataMessageService: CoreDataMessageServiceProtocol,
         firestoreService: FireStoreServiceProtocol,
         gcdService: ProfileDataServiceProtocol,
         channelId: String) {
        self.coreDataMessageService = coreDataMessageService
        self.firestoreService = firestoreService
        self.gcdService = gcdService
        self.channelId = channelId
        
        gcdService.readData { _ in }
    }
    
    func fetchMessages() {
        firestoreService.fetchMessages(channelId: channelId) {[weak self] message, action  in
            guard let self = self else { return }
            self.coreDataMessageService.performMessageAction(message: message, channelId: self.channelId, actionType: action)
        }
    }
    
    func sendMessage(message: String) {
        firestoreService.createMessage(channelId: channelId, message: message,
                                       senderName: gcdService.currentProfile?.userName ?? "No name")
    }
    
}
