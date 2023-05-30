//
//  CategoriesFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct CategoriesFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = false
        var categories: [CategoryResponse] = []
        var path: [Destination] = []
        var alert: AlertState<Action>?
        
        enum Destination: Equatable, Hashable {
            case create
        }
    }
    
    enum Action: Equatable {
        case fetchCategories
        case deleteCategory(_ id: String)
        case createCategory
        case navigationPathChanged([State.Destination])
        case copyButtonTapped(CategoryResponse)
        case copyButtonAlertDismissed
        
        case deleteResponse(_ id: String)
        case categoriesResponse([CategoryResponse])
    }
    
    @Dependency(\.categoriesClient) var categoriesClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .copyButtonTapped(let category):
            let id = category.id.uuidString
            UIPasteboard.general.string = id
            state.alert = AlertState {
                TextState("Copied categoryID: \(id) 🏷️")
            }
            return .none
        case .copyButtonAlertDismissed:
            state.alert = nil
            return .none
        case .fetchCategories:
            state.isLoading = true
            return .run { send in
                try await send(.categoriesResponse(self.categoriesClient.all()))
            }
        case .deleteCategory(let id):
            return .run { send in
                try await self.categoriesClient.delete(id)
                await send(.deleteResponse(id))
            }
        case .createCategory:
            state.path.append(.create)
            return .none
        case .deleteResponse(let id):
            state.categories.removeAll(where: { $0.id.uuidString == id })
            return .none
        case .categoriesResponse(let categories):
            state.categories = categories
            state.isLoading = false
            return .none
        case let .navigationPathChanged(path):
            state.path = path
            return .none
        }
    }
}
