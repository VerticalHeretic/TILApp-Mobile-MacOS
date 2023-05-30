//
//  UsersClient.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import Foundation
import ComposableArchitecture

struct UsersClient {
    var all: () async throws -> [UserResponse]
    var single: (String) async throws -> UserResponse
    var acronyms: (String) async throws -> [AcronymResponse]
    var create: (UserRequest) async throws -> UserResponse
    var delete: (_ id: String) async throws -> Void
}

extension UsersClient: DependencyKey {
    static var liveValue = UsersClient(
        all: {
            return try await URLSession.shared.request(for: .getUsers)
        },
        single: { id in
            return try await URLSession.shared.request(for: .getUser(id: id))
        },
        acronyms: { id in
            return try await URLSession.shared.request(for: .getUsersAcronyms(id: id))
        },
        create: { body in
            return try await URLSession.shared.request(for: .createUser(body: body))
        },
        delete: { id in
            let _: EmptyResponse = try await URLSession.shared.request(for: .deleteUser(id: id))
        }
    )
}

extension DependencyValues {
    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}
