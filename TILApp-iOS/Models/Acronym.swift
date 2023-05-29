//
//  Acronym.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

struct AcronymResponse: Codable, Equatable, Identifiable, Hashable {
    let id: UUID
    let short: String
    let long: String
    let user: AcronymUser
}

struct AcronymUser: Codable, Equatable, Identifiable, Hashable {
    let id: UUID
}

struct AcronymRequest: Codable, Hashable {
    let short: String
    let long: String
    let userID: String
}
