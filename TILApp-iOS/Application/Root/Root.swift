//
//  MainFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation
import ComposableArchitecture

struct Root: ReducerProtocol {
    
    struct State: Equatable {
        enum Tab {
            case acronyms
            case users
            case categories
        }
        
        var selectedTab: Tab = .acronyms
        var acronyms = AcronymsFeature.State()
        var users = UsersFeature.State()
        var categories = CategoriesFeature.State()
    }
    
    enum Action: Equatable {
        case selectedTabChange(State.Tab)
        case acronyms(AcronymsFeature.Action)
        case users(UsersFeature.Action)
        case categories(CategoriesFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectedTabChange(let tab):
                state.selectedTab = tab
                return .none
                
            default:
                return .none
            }
        }
        
        Scope(state: \.acronyms, action: /Action.acronyms) {
            AcronymsFeature()
        }
        
        Scope(state: \.users, action: /Action.users) {
            UsersFeature()
        }
        
        Scope(state: \.categories, action: /Action.categories) {
            CategoriesFeature()
        }
    }
}
