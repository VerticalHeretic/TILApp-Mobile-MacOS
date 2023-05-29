//
//  URLComponents+Categories.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import Foundation

extension URLComponents {
    
    static var categories: Self {
        return Self(path: "/api/categories")
    }
    
    static func category(id: String) -> Self {
        return Self(path: "/api/categories/\(id)")
    }
}
