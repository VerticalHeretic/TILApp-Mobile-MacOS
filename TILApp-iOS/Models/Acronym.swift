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
}

struct AcronymRequest: Codable, Hashable {
    let short: String
    let long: String
    let userID: String
}
