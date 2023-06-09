//
//  URLRequest+Categories.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import Foundation

extension URLRequest {
    
    static var getCategories: Self {
        Self(components: .categories)
    }
    
    static func getCategory(id: String) -> Self {
        Self(components: .category(id: id))
    }
    
    static func createCategory(body: CategoryRequest) -> Self {
        Self(components: .categories)
            .add(httpMethod: .post)
            .add(body: body)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
            .add(headers: ["Content-Type": "application/json"])
    }
    
    static func deleteCategory(id: String) -> Self {
        Self(components: .category(id: id))
            .add(httpMethod: .delete)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
    }
}
