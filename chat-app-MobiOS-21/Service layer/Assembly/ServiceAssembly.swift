//
//  ServiceAssembly.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

protocol ServiceAssemblyProtocol {
    var fireStoreService: FireStoreServiceProtocol { get }
    var coreDataChannelService: CoreDataChannelServiceProtocol { get }
    var coreDataMessageService: CoreDataMessageServiceProtocol { get }
    var gcdService: ProfileDataServiceProtocol { get }
    var operationService: ProfileDataServiceProtocol { get }
    var networkService: NetworkServiceProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    lazy var coreDataChannelService: CoreDataChannelServiceProtocol = CoreDataChannelService(coreDataStack: coreAssembly.coreDataStack)
    lazy var coreDataMessageService: CoreDataMessageServiceProtocol = CoreDataMessageService(coreDataStack: coreAssembly.coreDataStack)
    lazy var fireStoreService: FireStoreServiceProtocol = FireStoreService()
    lazy var gcdService: ProfileDataServiceProtocol = GCDDataService(fileManager: coreAssembly.fileManagerComponent)
    lazy var operationService: ProfileDataServiceProtocol = OperationDataService(fileManager: coreAssembly.fileManagerComponent)
    lazy var networkService: NetworkServiceProtocol = NetwrokService(requestSender: coreAssembly.requestSender,
                                                                     concurencySender: coreAssembly.concurencySender)
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
}
