//
//  CategoriesClient.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import Foundation
import ComposableArchitecture

struct CategoriesClient {
    var all: () async throws -> [CategoryResponse]
    var single: (String) async throws -> CategoryResponse
    var create: (CategoryRequest) async throws -> CategoryResponse
}

extension CategoriesClient: DependencyKey {
    static var liveValue = CategoriesClient(
        all: {
            return try await URLSession.shared.request(for: .getCategories)
        },
        single: { id in
            return try await URLSession.shared.request(for: .getCategory(id: id))
        },
        create: { body in
            return try await URLSession.shared.request(for: .createCategory(body: body))
        }
    )
}

extension DependencyValues {
    var categoriesClient: CategoriesClient {
        get { self[CategoriesClient.self] }
        set { self[CategoriesClient.self] = newValue }
    }
}
