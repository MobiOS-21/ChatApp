//
//  CoreDataStack.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.11.2021.
//

import CoreData

enum DBAction {
    case add, edit, remove
}

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Core Data Saving support
    private func saveContext(context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
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
        saveContext(context: backgroundContext)
    }
    
    private func saveChannel(channel: Channel) {
        let context = backgroundContext
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
        backgroundContext.delete(dbchannel)
    }
    
    private func getDBChannel(by id: String) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        guard let dbchannel = try? backgroundContext.fetch(fetchRequest).first else {
            return nil
        }
        return dbchannel
    }
    
    func getChannels() {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        do {
            _ = try mainContext.fetch(fetchRequest)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

// MARK: - Message actions
extension CoreDataStack {
    
}
