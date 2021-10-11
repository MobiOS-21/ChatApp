//
//  ConversationModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 05.10.2021.
//

import Foundation
protocol MessageCellConfiguration: AnyObject {
    var text: String? { get set }
    var isMyMessage: Bool { get set }
}

class ConversationModel: MessageCellConfiguration {
    var text: String?
    var isMyMessage: Bool
    
    init(text: String?, isMyMessage: Bool) {
        self.isMyMessage = isMyMessage
        self.text = text
    }
}
