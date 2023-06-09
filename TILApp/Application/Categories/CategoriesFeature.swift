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
        var categories: [CategoryResponse] = []
        var path = NavigationPath()
        var alert: AlertState<Action>?
        var categoryState = CategoryFeature.State()
        @BindingState var error: String?
        @BindingState var isLoading = false
        
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
        case errorResponse(String)
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
            case .category(.categoryResponse(let category)):
                state.categories.append(category)
                return .none
            case .category:
                return .none
            case .binding:
                return .none
            case .fetchCategories:
                state.isLoading = true
                return .run { send in
                    do {
                        let categories = try await self.categoriesClient.all()
                        await send(.categoriesResponse(categories))
                    } catch {
                        await send(.errorResponse(error.localizedDescription))
                    }
                }
            case .deleteCategory(let id):
                state.isLoading = true
                return .run { send in
                    do {
                        try await self.categoriesClient.delete(id)
                        await send(.deleteResponse(id))
                    } catch {
                        await send(.errorResponse(error.localizedDescription))
                    }
                }
            case .createCategory:
                state.path.append(State.Destination.create)
                return .none
            case .deleteResponse(let id):
                state.categories.removeAll(where: { $0.id.uuidString == id })
                state.isLoading = false
                return .none
            case .categoriesResponse(let categories):
                state.error = nil
                state.categories = categories
                state.isLoading = false
                return .none
            case .errorResponse(let errorMessage):
                state.isLoading = false
                state.error = errorMessage
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
