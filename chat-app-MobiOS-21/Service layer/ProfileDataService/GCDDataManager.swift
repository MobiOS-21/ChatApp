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
}

class GCDDataService: ProfileDataServiceProtocol {
    private let fileManager: ProfileFileManagerProtocol
    init(fileManager: ProfileFileManagerProtocol) {
        self.fileManager = fileManager
    }
    
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            completion(self.fileManager.saveProfile(profile: profile))
        }
    }
    
    func readData(completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            completion(self.fileManager.readProfileInfo())
        }
    }
}
