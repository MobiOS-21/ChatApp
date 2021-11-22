//
//  CoreDataMessageService.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 17.11.2021.
//

import CoreData

protocol CoreDataMessageServiceProtocol: CoreDataServiceProtocol {
    func performMessageAction(message: Message, channelId: String, actionType: DBAction)
}

class CoreDataMessageService: CoreDataMessageServiceProtocol {
    let coreDataStack: CoreDataStackProtocol
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    var mainContext: NSManagedObjectContext {
        coreDataStack.mainContext
    }
    
    func performMessageAction(message: Message, channelId: String, actionType: DBAction) {
        switch actionType {
        case .add:
            saveMessage(message: message, channelId: channelId)
        case .edit:
            editMessage(message: message)
        case .remove:
            removeMessage(message: message)
        }
        coreDataStack.saveContext(context: coreDataStack.backgroundContext)
    }
    
    private func saveMessage(message: Message, channelId: String) {
        let context = coreDataStack.backgroundContext
        guard let dbchannel = getDBChannel(by: channelId) else { return }
        let dbMessage = DBMessage(model: message, in: context)
        dbchannel.addToMessages(dbMessage)
    }
    
    private func editMessage(message: Message) {
        guard let dbMessage = getDBMessage(by: message) else {
            return
        }
        dbMessage.created = message.created
        dbMessage.senderId = message.senderId
        dbMessage.content = message.content
        dbMessage.senderName = message.senderName
    }
    
    private func removeMessage(message: Message) {
        guard let dbMessage = getDBMessage(by: message) else {
            return
        }
        coreDataStack.backgroundContext.delete(dbMessage)
    }
    
    private func getDBMessage(by message: Message) -> DBMessage? {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        let predicate = NSPredicate(format: "content == %@ && senderId == %@ && created == %@",
                                    message.content, message.senderId, message.created as NSDate)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        guard let dbMessage = try? coreDataStack.backgroundContext.fetch(fetchRequest).first else {
            return nil
        }
        return dbMessage
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
