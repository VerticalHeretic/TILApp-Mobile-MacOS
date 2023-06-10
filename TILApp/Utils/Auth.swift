//
//  Auth.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 01/06/2023.
//

import Foundation
import ComposableArchitecture

final class Auth {
    
    static let shared = Auth()
    
    static let keychainKey = "TIL-API-KEY"
    
    @Dependency(\.usersClient) var usersClient
    
    var token: String? {
        get {
            Keychain.load(key: Auth.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: Auth.keychainKey, data: newToken)
            } else {
                Keychain.delete(key: Auth.keychainKey)
            }
        }
    }
    
    func logout() {
        token = nil
    }
    
    func login(signInWithAppleToken: SignInWithAppleToken) async throws {
        let token = try await usersClient.loginWithApple(signInWithAppleToken)
        LoggerClient.authLogger.info("Signed in with Apple")
        self.token = token.value
    }
}
