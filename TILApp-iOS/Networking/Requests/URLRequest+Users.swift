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
}
