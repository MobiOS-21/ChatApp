//
//  ChannelViewModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 18.11.2021.
//

import CoreData

protocol ChannelViewModelProtocol {
    func createChannel(channelName: String)
    func fetchChannels()
    func deleteChannel(channelId: String)
    var fetchedResultsController: NSFetchedResultsController<DBChannel> { get }
}

class ChannelViewModel: ChannelViewModelProtocol {
    lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchRequest = DBChannel.fetchRequest()
        let sort1 = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sort2 = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 20
        
        let fetchedRequestController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataChannelService.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedRequestController
    }()
    
    private let coreDataChannelService: CoreDataChannelServiceProtocol
    private let firestoreService: FireStoreServiceProtocol
    
    init(coreDataChannelService: CoreDataChannelServiceProtocol, firestoreService: FireStoreServiceProtocol) {
        self.coreDataChannelService = coreDataChannelService
        self.firestoreService = firestoreService
    }
    
    func createChannel(channelName: String) {
        firestoreService.createChannel(channelName: channelName)
    }
    
    func fetchChannels() {
        firestoreService.fetchChannels {[weak self] channel, action  in
            guard let self = self else { return }
            self.coreDataChannelService.performChannelAction(channel: channel, actionType: action)
        }
    }
    
    func deleteChannel(channelId: String) {
        firestoreService.deleteChannel(channelId: channelId)
    }
}
