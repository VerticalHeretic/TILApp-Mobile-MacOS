//
//  URLComponents+Acronyms.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

extension URLComponents {
    
    static var acronyms: Self {
        return Self(path: "/api/acronyms")
    }
    
    static func acronym(id: String) -> Self {
        return Self(path: "/api/acronyms/\(id)")
    }
    
    static var acronymFirst: Self {
        return Self(path: "/api/acronyms/first")
    }
    
    static var acronymsSorted: Self {
        return Self(path: "/api/acronyms/sorted")
    }
    
    static func acronymSearch(term: String) -> Self {
        let queryItems: [URLQueryItem] = [.init(name: "term", value: term)]
        return Self(path: "/api/acronyms/search", queryItems: queryItems)
    }
    
    static func acronymUser(id: String) -> Self {
        return Self(path: "/api/acronyms/\(id)/user")
    }
    
    static func acronymCategories(id: String) -> Self {
        return Self(path: "/api/acronyms/\(id)/categories")
    }
    
    static func acronymModifyCategory(id: String, categoryID: String) -> Self {
        return Self(path: "/api/acronyms/\(id)/categories/\(categoryID)")
    }
}
