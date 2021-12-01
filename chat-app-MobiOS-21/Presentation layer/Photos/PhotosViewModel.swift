//
//  PhotosViewModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

protocol PhotosViewModelProtocol {
    func fetchImages(completion: @escaping (([URL]) -> Void))
    @available(iOS 15.0.0, *)
    func fetchConcurencyImages() async throws -> [URL]
}

class PhotosViewModel: PhotosViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchImages(completion: @escaping (([URL]) -> Void)) {
        networkService.fetchImages { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    func fetchConcurencyImages() async throws -> [URL] {
        try await networkService.fetchConcurencyImages()
    }
}
