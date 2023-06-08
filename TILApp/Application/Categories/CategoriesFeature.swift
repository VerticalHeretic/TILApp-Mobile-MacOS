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
        var path = NavigationPath()
        var alert: AlertState<Action>?
        var categoryState = CategoryFeature.State()
        
        enum Destination: Equatable, Hashable {
            case create
        }
    }
    
    enum Action: Equatable, BindableAction {
        case fetchCategories
        case deleteCategory(_ id: String)
        case createCategory
        case navigationPathChanged(NavigationPath)
        case copyButtonTapped(CategoryResponse)
        case copyButtonAlertDismissed
        case category(CategoryFeature.Action)
        case binding(BindingAction<State>)
        
        case deleteResponse(_ id: String)
        case categoriesResponse([CategoryResponse])
    }
    
    @Dependency(\.categoriesClient) var categoriesClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .copyButtonTapped(let category):
                let id = category.id.uuidString
#if os(iOS)
                UIPasteboard.general.string = id
                state.alert = AlertState {
                    TextState("Copied categoryID: \(id) 🏷️")
                }
#else
                NSPasteboard.general.setString(id, forType: .string) // TODO: Not working, need to add some capabilities for macOS sandbox I suppose. Will fix later.
#endif
                return .none
            case .copyButtonAlertDismissed:
                state.alert = nil
                return .none
            case .category:
                return .none
            case .binding:
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
                state.path.append(State.Destination.create)
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
    
        Scope(state: \.categoryState, action: /Action.category) {
            CategoryFeature()
        }
    }
}
