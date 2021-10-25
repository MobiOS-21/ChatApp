//
//  ConversationsModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.10.2021.
//

import Foundation
protocol ChannelsCellConfiguration: AnyObject {
    var identifier: String { get set }
    var name: String { get set }
    var lastMessage: String? { get set }
    var lastActivity: Date? { get set }
}

class Channel: ChannelsCellConfiguration {
    var identifier: String
    var name: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
