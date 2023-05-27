//
//  URLComponents+Users.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import Foundation

extension URLComponents {
    
    static var users: Self {
        return Self(path: "/api/users")
    }
    
}
