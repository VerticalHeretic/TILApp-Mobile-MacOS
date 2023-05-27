//
//  Acronym.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

struct AcronymResponse: Codable, Equatable, Identifiable {
    let id: UUID
    let short: String
    let long: String
}

struct AcronymRequest: Codable {
    let short: String
    let long: String
    let userID: String
}
