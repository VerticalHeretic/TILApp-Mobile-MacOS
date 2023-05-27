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
}

extension UsersClient: DependencyKey {
    static var liveValue = UsersClient(
        all: {
            return try await URLSession.shared.request(for: .getUsers)
        }
    )
}

extension DependencyValues {
    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}
