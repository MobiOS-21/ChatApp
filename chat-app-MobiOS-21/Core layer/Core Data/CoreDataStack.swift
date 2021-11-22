//
//  CoreDataStack.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.11.2021.
//

import CoreData

protocol CoreDataStackProtocol {
    var mainContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    func saveContext(context: NSManagedObjectContext)
    func printSQLiteDB()
}

class CoreDataStack: CoreDataStackProtocol {
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
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
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    // MARK: - Core Data Saving support
    func saveContext(context: NSManagedObjectContext) {
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
    
    func printSQLiteDB() {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        do {
            let channels = try mainContext.fetch(fetchRequest)
            print("Всего каналов: \(channels.count)")
            for channel in channels {
                print("{channel name: \(channel.name ?? "")\nchannel identifier: \(channel.identifier ?? "")")
                guard let messages = channel.messages as? Set<DBMessage> else { continue }
                print("messages count: \(messages.count) [")
                let messagesInfo = messages.compactMap({ "senderName: \($0.senderName ?? ""), content: \($0.content ?? "") \n" }).reduce("", +)
                print(messagesInfo + "]} \n")
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
