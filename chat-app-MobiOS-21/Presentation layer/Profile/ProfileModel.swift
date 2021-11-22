//
//  ProfileModel.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 20.10.2021.
//

import Foundation

struct ProfileModel: Codable {
    let userName: String?
    let userDecription: String?
    let userAvater: Data?
}
