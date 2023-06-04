//
//  URLRequest+Acronyms.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation

extension URLRequest {
    
    static var getAcronyms: Self {
        Self(components: .acronyms)
    }
    
    static func getAcronym(id: String) -> Self {
        Self(components: .acronym(id: id))
    }
    
    static var getFirstAcronym: Self {
        Self(components: .acronymFirst)
    }
    
    static var getSortedAcronyms: Self {
        Self(components: .acronymsSorted)
    }
    
    static func searchAcronyms(term: String) -> Self {
        Self(components: .acronymSearch(term: term))
    }
    
    static func getAcronymUser(id: String) -> Self {
        Self(components: .acronymUser(id: id))
    }
    
    static func getAcronymCategories(id: String) -> Self {
        Self(components: .acronymCategories(id: id))
    }
    
    static func addCategoryToAcronym(id: String, categoryID: String) -> Self {
        Self(components: .acronymModifyCategory(id: id, categoryID: categoryID))
            .add(httpMethod: .post)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
    }
    
    static func deleteCategoryFromAcronym(id: String, categoryID: String) -> Self {
        Self(components: .acronymModifyCategory(id: id, categoryID: categoryID))
            .add(httpMethod: .delete)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
    }
    
    static func createAcronym(body: AcronymRequest) -> Self {
        Self(components: .acronyms)
            .add(httpMethod: .post)
            .add(body: body)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
            .add(headers: ["Content-Type": "application/json"])
    }
    
    static func updateAcronym(id: String, body: AcronymRequest) -> Self {
        Self(components: .acronym(id: id))
            .add(httpMethod: .put)
            .add(body: body)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
            .add(headers: ["Content-Type": "application/json"])
    }
    
    static func deleteAcronym(id: String) -> Self {
        Self(components: .acronym(id: id))
            .add(httpMethod: .delete)
            .add(headers: ["Authorization": "Bearer \(Auth.shared.token ?? "")"])
    }
    
}
