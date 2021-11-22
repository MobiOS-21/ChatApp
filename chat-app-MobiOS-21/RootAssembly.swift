//
//  RootAssembly.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.11.2021.
//

class RootAssembly {
    lazy var presentationAssembly: PresentationAssemblyProtocol = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: ServiceAssemblyProtocol = ServiceAssembly(coreAssembly: self.coreAssembly)
    lazy var coreAssembly: CoreAssemblyProtocol = CoreAssembly()
}
