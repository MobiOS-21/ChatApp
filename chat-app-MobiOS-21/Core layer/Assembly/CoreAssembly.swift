//
//  CoreAssembly.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

protocol CoreAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol { get set }
    var fileManagerComponent: ProfileFileManagerProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    lazy var fileManagerComponent: ProfileFileManagerProtocol = ProfileFileManager()
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack()
}
