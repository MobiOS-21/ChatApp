//
//  OperationFileManager.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

class OperationDataManager: ProfileDataManagerProtocol {
    func saveData(profile: ProfileModel, completion: @escaping (FileManagerStatus) -> Void) {
        let saveOpeartion = SaveProfileOperation()
        saveOpeartion.profile = profile
        saveOpeartion.resultCompletion = { status in
            completion(status)
        }
        
        let queue = OperationQueue()
        queue.name = "com.mobios.saveOperation"
        queue.addOperation(saveOpeartion)
    }
    
    func readData(completion: @escaping (FileManagerStatus) -> Void) {
        let readOpeartion = ReadProfileOperation()
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
    override func main() {
        resultCompletion?(ProfileFileManager.shared.readProfileInfo())
    }
}

class SaveProfileOperation: Operation {
    var resultCompletion: ((FileManagerStatus) -> Void)?
    var profile: ProfileModel?
    override func main() {
        guard let profile = profile else {
            resultCompletion?(.error)
            return
        }
        resultCompletion?(ProfileFileManager.shared.saveProfile(profile: profile))
    }
}
