//
//  CoreDataChannelService.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 17.11.2021.
//

import CoreData

enum DBAction {
    case add, edit, remove
}

protocol CoreDataServiceProtocol {
    var mainContext: NSManagedObjectContext { get }
}

protocol CoreDataChannelServiceProtocol: CoreDataServiceProtocol {
    func performChannelAction(channel: Channel, actionType: DBAction)
}

class CoreDataChannelService: CoreDataChannelServiceProtocol {
    let coreDataStack: CoreDataStackProtocol
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    var mainContext: NSManagedObjectContext {
        coreDataStack.mainContext
    }
    
    // MARK: - Channel actions
    func performChannelAction(channel: Channel, actionType: DBAction) {
        switch actionType {
        case .add:
            saveChannel(channel: channel)
        case .edit:
            editChannel(channel: channel)
        case .remove:
            removeChannel(channel: channel)
        }
        coreDataStack.saveContext(context: coreDataStack.backgroundContext)
    }
    
    private func saveChannel(channel: Channel) {
        let context = coreDataStack.backgroundContext
        _ = DBChannel(model: channel, in: context)
    }
    
    private func editChannel(channel: Channel) {
        guard let dbchannel = getDBChannel(by: channel.identifier) else {
            return
        }
        dbchannel.identifier = channel.identifier
        dbchannel.lastActivity = channel.lastActivity
        dbchannel.lastMessage = channel.lastMessage
        dbchannel.name = channel.name
    }
    
    private func removeChannel(channel: Channel) {
        guard let dbchannel = getDBChannel(by: channel.identifier) else {
            return
        }
        coreDataStack.backgroundContext.delete(dbchannel)
    }
    
    private func getDBChannel(by id: String) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        guard let dbchannel = try? coreDataStack.backgroundContext.fetch(fetchRequest).first else {
            return nil
        }
        return dbchannel
    }
}
