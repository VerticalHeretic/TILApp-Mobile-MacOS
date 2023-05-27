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
    var update: (_ id: String, _ body: AcronymRequest) async throws -> AcronymResponse
    var delete: (_ id: String) async throws -> ()
    var user: (_ id: String) async throws -> UserResponse
    var categories: (_ id: String) async throws -> [CategoryResponse]
    var addCategory: (_ id: String, _ categoryID: String) async throws -> ()
    var deleteCategory: (_ id: String, _ categoryID: String) async throws -> ()
}

extension AcronymsClient: DependencyKey {
    static let liveValue = AcronymsClient(
        all: {
            let acronyms: [AcronymResponse] = try await URLSession.shared.request(for: .getAcronyms)
            return acronyms
        },
        sorted: {
            let acronyms: [AcronymResponse] = try await URLSession.shared.request(for: .getSortedAcronyms)
            return acronyms
        },
        first: {
            let acronym: AcronymResponse = try await URLSession.shared.request(for: .getFirstAcronym)
            return acronym
        },
        single: { id in
            let acronym: AcronymResponse = try await URLSession.shared.request(for: .getAcronym(id: id))
            return acronym
        },
        create: { body in
            let acronym: AcronymResponse = try await URLSession.shared.request(for: .createAcronym(body: body))
            return acronym
        },
        update: { id, body in
            let acronym: AcronymResponse = try await URLSession.shared.request(for: .updateAcronym(id: id, body: body))
            return acronym
        },
        delete: { id in
            let _: EmptyResponse = try await URLSession.shared.request(for: .deleteAcronym(id: id))
        },
        user: { id in
            let user: UserResponse = try await URLSession.shared.request(for: .getAcronymUser(id: id))
            return user
        },
        categories: { id in
            let categories: [CategoryResponse] = try await URLSession.shared.request(for: .getAcronymCategories(id: id))
            return categories
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
