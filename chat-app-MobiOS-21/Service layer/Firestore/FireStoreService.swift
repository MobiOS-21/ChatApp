//
//  FireStoreService.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

import Foundation
import FirebaseFirestore

// MARK: Protocol
protocol FireStoreServiceProtocol {
    func fetchChannels(completion: @escaping (Channel, DBAction) -> Void)
    func createChannel(channelName: String)
    func deleteChannel(channelId: String)
    func fetchMessages(channelId: String, completion: @escaping (Message, DBAction) -> Void)
    func createMessage(channelId: String, message: String, senderName: String)
}

class FireStoreService: FireStoreServiceProtocol {
    // MARK: - Properties
    private lazy var reference = db.collection("channels")
    private lazy var db = Firestore.firestore()
    // MARK: - FireStoreServiceProtocol
    func fetchChannels(completion: @escaping (Channel, DBAction) -> Void) {
        reference.addSnapshotListener {querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                var name: String = ""
                var lastActivity: Date?
                if let documentName = diff.document["name"] as? String {
                    name = documentName
                }
                if let documentDate = diff.document["lastActivity"] as? Timestamp {
                    lastActivity = Date(timeIntervalSince1970: TimeInterval(documentDate.seconds))
                }
                let channel = Channel(identifier: diff.document.documentID,
                                      name: name,
                                      lastMessage: diff.document["lastMessage"] as? String,
                                      lastActivity: lastActivity)
                switch diff.type {
                case .added:
                    completion(channel, .add)
                case .modified:
                    completion(channel, .edit)
                case .removed:
                    completion(channel, .remove)
                }
            }
        }
    }
    
    func createChannel(channelName: String) {
        let channel = Channel(identifier: UUID().uuidString, name: channelName, lastMessage: nil, lastActivity: nil)
        reference.addDocument(data: channel.dictionary)
    }
    
    func deleteChannel(channelId: String) {
        reference.document(channelId).delete()
    }
    
    func fetchMessages(channelId: String, completion: @escaping (Message, DBAction) -> Void) {
        let messageReference = reference.document(channelId).collection("messages")
        messageReference.addSnapshotListener {querySnapshot, error in
            guard  let snapshot = querySnapshot else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let content = diff.document["content"] as? String else {
                    fatalError()
                }
                guard let createdTimestamp = diff.document["created"] as? Timestamp else {
                    fatalError()
                }
                var senderId: String = ""
                // сделал так потому что кто-то кидает senderID, а кто-то senderId
                if let senderID = diff.document["senderID"] as? String {
                    senderId = senderID
                } else if let senderID = diff.document["senderId"] as? String {
                    senderId = senderID
                }
                guard var senderName = diff.document["senderName"] as? String else {
                    fatalError()
                }
                if senderName.isEmpty { senderName = "No name" }
                let message = Message(content: content,
                                      created: Date(timeIntervalSince1970: TimeInterval(createdTimestamp.seconds)),
                                      senderId: senderId,
                                      senderName: senderName)
                switch diff.type {
                case .added:
                    completion(message, .add)
                case .modified:
                    completion(message, .edit)
                case .removed:
                    completion(message, .remove)
                }
            }
        }
    }
    
    func createMessage(channelId: String, message: String, senderName: String) {
        let messageReference = reference.document(channelId).collection("messages")
        let message = Message(content: message, created: Date(), senderName: senderName)
        messageReference.addDocument(data: message.toDict)
    }
}
