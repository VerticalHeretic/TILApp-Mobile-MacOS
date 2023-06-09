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
        enum Tab: String, CaseIterable, Identifiable {
            var id: Self {
                return self
            }
            
            case acronyms = "Acronyms"
            case users = "Users"
            case categories = "Categories"
        }
        
        var isAuthenthicated: Bool = Auth.shared.token != nil
        var selectedTab: Tab = .acronyms
        var acronyms = AcronymsFeature.State()
        var users = UsersFeature.State()
        var categories = CategoriesFeature.State()
        var loginState = LoginFeature.State()
    }
    
    enum Action: Equatable {
        case selectedTabChange(State.Tab)
        case acronyms(AcronymsFeature.Action)
        case users(UsersFeature.Action)
        case categories(CategoriesFeature.Action)
        case login(LoginFeature.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectedTabChange(let tab):
                state.selectedTab = tab
                return .none
            case .login(.loginTapped):
                debugPrint("This is a print from root for login tapped")
                return .none
            case .login(.loginResponse):
                state.isAuthenthicated = true
                return .none
            case .acronyms(.logout):
                Auth.shared.logout()
                state.isAuthenthicated = false
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
        
        Scope(state: \.loginState, action: /Action.login) {
            LoginFeature()
        }
    }
}
