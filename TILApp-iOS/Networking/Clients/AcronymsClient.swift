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
    var user: (_ id: String) async throws -> UserResponse
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
        user: { id in
            let user: UserResponse = try await URLSession.shared.request(for: .getAcronymUser(id: id))
            return user
        })
}

extension DependencyValues {
    var acronymsClient: AcronymsClient {
        get { self[AcronymsClient.self] }
        set { self[AcronymsClient.self] = newValue }
    }
}
