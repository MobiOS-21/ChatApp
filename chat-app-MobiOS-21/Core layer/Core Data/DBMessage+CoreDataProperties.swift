//
//  DBMessage+CoreDataProperties.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 02.11.2021.
//
//

import Foundation
import CoreData

extension DBMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBMessage> {
        return NSFetchRequest<DBMessage>(entityName: "DBMessage")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var senderId: String?
    @NSManaged public var senderName: String?
    @NSManaged public var channel: DBChannel?

}

extension DBMessage {
    convenience init(model: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = model.content
        self.created = model.created
        self.senderId = model.senderId
        self.senderName = model.senderName
    }
}
