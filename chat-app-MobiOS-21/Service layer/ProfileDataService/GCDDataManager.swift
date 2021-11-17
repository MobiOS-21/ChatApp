//
//  GCDFileManager.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

protocol ProfileDataServiceProtocol {
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void)
    func readData(completion: @escaping (FileManagerStatus) -> Void)
    var currentProfile: ProfileModel? { get }
}

class GCDDataService: ProfileDataServiceProtocol {
    lazy var currentProfile: ProfileModel? = fileManager.currentProfile
    private let fileManager: ProfileFileManagerProtocol
    
    init(fileManager: ProfileFileManagerProtocol) {
        self.fileManager = fileManager
        NotificationCenter.default.addObserver(forName: Notification.Name("didEditProfile"),
                                               object: nil, queue: nil) { notification in
            guard let userInfo = notification.userInfo as? [String: ProfileModel] else { return }
            self.currentProfile = userInfo["profile"]
        }
    }
    
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            completion(self.fileManager.saveProfile(profile: profile))
            self.currentProfile = self.fileManager.currentProfile
        }
    }
    
    func readData(completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            completion(self.fileManager.readProfileInfo())
            self.currentProfile = self.fileManager.currentProfile
        }
    }
}
