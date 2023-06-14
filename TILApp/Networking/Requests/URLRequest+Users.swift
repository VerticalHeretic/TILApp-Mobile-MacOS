//
//  URLRequest+Users.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import Foundation

extension URLRequest {
    
    static var getUsers: Self {
        Self(components: .users)
    }
    
    static func getUser(id: String) -> Self {
        Self(components: .user(id: id))
    }
    
    static func getUsersAcronyms(id: String) -> Self {
        Self(components: .usersAcronyms(id: id))
    }
    
    static func register(body: UserRequest) -> Self {
        Self(components: .users)
            .add(httpMethod: .post)
            .add(body: body)
            .add(headers: ["Content-Type": "application/json"])
    }
    
    static func deleteUser(id: String) -> Self {
        Self(components: .user(id: id))
            .add(httpMethod: .delete)
    }
    
    static func login(credentials: LoginData) -> Self {
        guard let loginString = credentials.loginString else {
            fatalError("Failed to encode credentials")
        }
        
        return Self(components: .login)
            .add(headers: ["Authorization": "Basic \(loginString)"])
            .add(httpMethod: .post)
    }
    
    static func login(token: SignInWithAppleToken) -> Self {
        return Self(components: .loginSIWA)
            .add(httpMethod: .post)
            .add(body: token)
            .add(headers: ["Content-Type": "application/json"])
    }
    
    static func addProfilePhoto(imageData: ImageUploadData) -> Self {
        return Self(components: .userProfilePicture)
            .add(httpMethod: .post)
            .add(body: imageData)
            .add(headers: ["Content-Type": "application/json"])
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
    }
    
    static func getProfilePhoto(id: String) -> Self {
        return Self(components: .profilePicture(id: id))
            .add(httpMethod: .get)
    }
}
