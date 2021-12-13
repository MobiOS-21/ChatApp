//
//  ProfileFileManagerMock.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 11.12.2021.
//

import Foundation
@testable import chat_app_MobiOS_21

class ProfileFileManagerMock: ProfileFileManagerProtocol {
    var numberOfCalls: Int = 0
    
    func saveProfile(profile: ProfileModel) -> FileManagerStatus {
        numberOfCalls += 1
        currentProfile = profile
        return .success
    }
    
    func readProfileInfo() -> FileManagerStatus {
        numberOfCalls += 1
        return .success
    }
    
    var currentProfile: ProfileModel?
}
