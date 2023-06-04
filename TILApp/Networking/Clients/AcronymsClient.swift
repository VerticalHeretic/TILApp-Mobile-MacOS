//
//  AcronymsClient.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation
import ComposableArchitecture

struct AcronymsClient {
    var all: () async throws -> [AcronymResponse]
    var sorted: () async throws -> [AcronymResponse]
    var first: () async throws -> AcronymResponse
    var single: (_ id: String) async throws -> AcronymResponse
    var create: (_ body: AcronymRequest) async throws -> AcronymResponse
    var search: (_ term: String) async throws -> [AcronymResponse]
    var update: (_ id: String, _ body: AcronymRequest) async throws -> AcronymResponse
    var delete: (_ id: String) async throws -> Void
    var user: (_ id: String) async throws -> UserResponse
    var categories: (_ id: String) async throws -> [CategoryResponse]
    var addCategory: (_ id: String, _ categoryID: String) async throws -> Void
    var deleteCategory: (_ id: String, _ categoryID: String) async throws -> Void
}

extension AcronymsClient: DependencyKey {
    static let liveValue = AcronymsClient(
        all: {
            try await URLSession.shared.request(for: .getAcronyms)
        },
        sorted: {
            try await URLSession.shared.request(for: .getSortedAcronyms)
        },
        first: {
            try await URLSession.shared.request(for: .getFirstAcronym)
        },
        single: { id in
            try await URLSession.shared.request(for: .getAcronym(id: id))
        },
        create: { body in
            try await URLSession.shared.request(for: .createAcronym(body: body))
        },
        search: { term in
            try await URLSession.shared.request(for: .searchAcronyms(term: term))
        },
        update: { id, body in
            try await URLSession.shared.request(for: .updateAcronym(id: id, body: body))
        },
        delete: { id in
            let _: EmptyResponse = try await URLSession.shared.request(for: .deleteAcronym(id: id))
        },
        user: { id in
            try await URLSession.shared.request(for: .getAcronymUser(id: id))
        },
        categories: { id in
            try await URLSession.shared.request(for: .getAcronymCategories(id: id))
        },
        addCategory: { id, categoryID in
            let _: EmptyResponse = try await URLSession.shared.request(for: .addCategoryToAcronym(id: id, categoryID: categoryID))
        },
        deleteCategory: { id, categoryID in
            let _: EmptyResponse = try await URLSession.shared.request(for: .deleteCategoryFromAcronym(id: id, categoryID: categoryID))
        })
}

extension DependencyValues {
    var acronymsClient: AcronymsClient {
        get { self[AcronymsClient.self] }
        set { self[AcronymsClient.self] = newValue }
    }
}
