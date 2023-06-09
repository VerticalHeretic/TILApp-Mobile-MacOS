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
    var register: (UserRequest) async throws -> UserResponse
    var delete: (_ id: String) async throws -> Void
    var login: (_ credentials: LoginData) async throws -> Void
    var loginWithApple: (_ token: SignInWithAppleToken) async throws -> Token
    var getProfilePicture: (_ id: String) async throws -> Data
    var addProfilePicture: (_ data: ImageUploadData) async throws -> Void
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
        register: { body in
            return try await URLSession.shared.request(for: .register(body: body))
        },
        delete: { id in
            let _: EmptyResponse = try await URLSession.shared.request(for: .deleteUser(id: id))
        },
        login: { credentials in
            let token: Token = try await URLSession.shared.request(for: .login(credentials: credentials))
            Auth.shared.token = token.value
        },
        loginWithApple: { signInToken in
            return try await URLSession.shared.request(for: .login(token: signInToken))
        },
        getProfilePicture: { id in
            return try await URLSession.shared.request(for: .getProfilePhoto(id: id))
        },
        addProfilePicture: { data in
            let _: EmptyResponse = try await URLSession.shared.request(for: .addProfilePhoto(imageData: data))
        }
    )
}

extension DependencyValues {
    var usersClient: UsersClient {
        get { self[UsersClient.self] }
        set { self[UsersClient.self] = newValue }
    }
}
