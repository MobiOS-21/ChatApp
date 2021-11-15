//
//  OperationFileManager.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

class OperationDataService: ProfileDataServiceProtocol {
    private let fileManager: ProfileFileManagerProtocol
    init(fileManager: ProfileFileManagerProtocol) {
        self.fileManager = fileManager
    }
    
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void) {
        let saveOpeartion = SaveProfileOperation(fileManager: fileManager, profile: profile)
        saveOpeartion.resultCompletion = { status in
            completion(status)
        }
        
        let queue = OperationQueue()
        queue.name = "com.mobios.saveOperation"
        queue.addOperation(saveOpeartion)
    }
    
    func readData(completion: @escaping (FileManagerStatus) -> Void) {
        let readOpeartion = ReadProfileOperation(fileManager: fileManager)
        readOpeartion.resultCompletion = { status in
            completion(status)
        }
        
        let queue = OperationQueue()
        queue.name = "com.mobios.readOperation"
        queue.addOperation(readOpeartion)
    }
}

class ReadProfileOperation: Operation {
    var resultCompletion: ((FileManagerStatus) -> Void)?
    private let fileManager: ProfileFileManagerProtocol
    
    init(fileManager: ProfileFileManagerProtocol) {
        self.fileManager = fileManager
    }
    
    override func main() {
        resultCompletion?(fileManager.readProfileInfo())
    }
}

class SaveProfileOperation: Operation {
    var resultCompletion: ((FileManagerStatus) -> Void)?
    private let profile: ProfileModel
    private let fileManager: ProfileFileManagerProtocol
    
    init(fileManager: ProfileFileManagerProtocol, profile: ProfileModel) {
        self.fileManager = fileManager
        self.profile = profile
    }
    
    override func main() {
        resultCompletion?(fileManager.saveProfile(profile: profile))
    }
}
