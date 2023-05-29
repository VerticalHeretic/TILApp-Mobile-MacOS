//
//  CategoriesFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import Foundation
import ComposableArchitecture

struct CategoriesFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = false
        var categories: [CategoryResponse] = []
    }
    
    enum Action: Equatable {
        case fetchCategories
        case categoriesResponse([CategoryResponse])
    }
    
    @Dependency(\.categoriesClient) var categoriesClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchCategories:
            state.isLoading = true
            return .run { send in
                try await send(.categoriesResponse(self.categoriesClient.all()))
            }
        case .categoriesResponse(let categories):
            state.categories = categories
            state.isLoading = false
            return .none
        }
    }
}
