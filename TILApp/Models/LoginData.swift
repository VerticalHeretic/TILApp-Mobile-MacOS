//
//  LoginData.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 01/06/2023.
//

import Foundation

struct LoginData {
    let username: String
    let password: String
}

extension LoginData {
    
    var loginString: String? {
        "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
    }
}
