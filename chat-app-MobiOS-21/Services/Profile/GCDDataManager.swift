//
//  GCDFileManager.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

class GCDDataManager: ProfileDataManagerProtocol {
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            completion(ProfileFileManager.shared.saveProfile(profile: profile))
        }
    }
    
    func readData(completion: @escaping (FileManagerStatus) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            completion(ProfileFileManager.shared.readProfileInfo())
        }
    }
}
