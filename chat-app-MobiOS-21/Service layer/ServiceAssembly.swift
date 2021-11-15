//
//  ServiceAssembly.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

protocol ServiceAssemblyProtocol {
    var fireStoreService: FireStoreServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var gcdService: DataManagerProtocol { get }
    var operationService: DataManagerProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    lazy var fireStoreService: FireStoreServiceProtocol = FireStoreService()
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(coreDataStack: coreAssembly.coreDataStack)
    lazy var gcdService: DataManagerProtocol = GCDDataManager(fileManager: coreAssembly.fileManagerComponent)
    lazy var operationService: DataManagerProtocol = OperationDataManager(fileManager: coreAssembly.fileManagerComponent)

    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
}
