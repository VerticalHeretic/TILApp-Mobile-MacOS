//
//  User.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

struct UserResponse: Codable, Equatable {
    let id: UUID
    let name: String
    let username: String
}
