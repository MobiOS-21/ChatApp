//
//  ConversationModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import FirebaseFirestore

protocol MessageCellConfiguration: AnyObject {
    var content: String { get set }
    var created: Date { get set }
    var senderId: String { get set }
    var senderName: String { get set }
}

class Message: MessageCellConfiguration {
    var content: String
    var created: Date
    var senderId: String
    var senderName: String

    init(content: String,
         created: Date,
         senderId: String = UIDevice.current.identifierForVendor?.uuidString ?? "",
         senderName: String = ProfileFileManager.shared.currentProfile?.userName ?? "No name") {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
    }
}
