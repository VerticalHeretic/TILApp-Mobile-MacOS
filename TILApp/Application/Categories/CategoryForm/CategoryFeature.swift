//
//  CategoryFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 30/05/2023.
//

import Foundation
import ComposableArchitecture

struct CategoryState: Equatable {
    @BindingState var name: String = ""
}

struct CategoryFeature: ReducerProtocol {
    
    typealias State = CategoryState
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveTapped
        case categoryResponse(CategoryResponse)
    }
    
    @Dependency(\.categoriesClient) var categoriesClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveTapped:
                return .run { [name = state.name] send in
                    let request = CategoryRequest(name: name)
                    
                    try await send(.categoryResponse(self.categoriesClient.create(request)))
                }
            case .categoryResponse:
                return .none
            }
        }
    }
}
