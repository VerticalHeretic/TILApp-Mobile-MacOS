//
//  Category.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

struct CategoryResponse: Codable, Equatable, Identifiable, Hashable {
    let id: UUID
    let name: String
}

struct CategoryRequest: Codable, Equatable {
    let name: String
}
