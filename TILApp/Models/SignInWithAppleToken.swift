//
//  SignInWithAppleToken.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 10/06/2023.
//

import Foundation

struct SignInWithAppleToken: Codable {
    let token: String
    let name: String?
}
