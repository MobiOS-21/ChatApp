//
//  ProfileFileManager.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

protocol ProfileDataManagerProtocol {
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void)
    func readData(completion: @escaping (FileManagerStatus) -> Void)
}

enum FileManagerStatus {
    case success, error
}

class ProfileFileManager {
    static let shared = ProfileFileManager()
    
    private init() {}
    
    var currentProfile: ProfileModel?
    
    func saveProfile(profile: ProfileModel) -> FileManagerStatus {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Profile.plist")
        do {
            let data = try encoder.encode(profile)
            try data.write(to: path)
            currentProfile = profile
            return .success
        } catch {
            print(error)
        }
        return .error
    }
    
    func readProfileInfo() -> FileManagerStatus {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Profile.plist")
        do {
            let profileData = try Data(contentsOf: path)
            let profile = try PropertyListDecoder().decode(ProfileModel.self, from: profileData)
            currentProfile = profile
            return .success
        } catch {
            print(error.localizedDescription)
        }
        return .error
    }
}
