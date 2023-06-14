//
//  User.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

struct UserResponse: Codable, Equatable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let username: String
    let profilePicture: String?
}

struct UserRequest: Codable, Hashable {
    let name: String
    let username: String
    let password: String
    let email: String
}
