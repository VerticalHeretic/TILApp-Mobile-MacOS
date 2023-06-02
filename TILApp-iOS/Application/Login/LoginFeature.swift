//
//  LoginFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 01/06/2023.
//

import Foundation
import ComposableArchitecture

struct LoginState: Equatable {
    @BindingState var username: String = ""
    @BindingState var password: String = ""
}

enum LoginAction: BindableAction, Equatable {
    case binding(BindingAction<LoginState>)
    case loginTapped
    case loginResponse
}

struct LoginFeature: ReducerProtocol {
    
    typealias State = LoginState
    typealias Action = LoginAction
    
    @Dependency(\.usersClient) var userClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .loginTapped:
                debugPrint("Login")
                return .run { [password = state.password, username = state.username] send in
                    do {
                        try await self.userClient.login(.init(username: username, password: password))
                        await send(.loginResponse)
                    } catch {
                        debugPrint("DEBUG", error)
                    }
                }
            case .loginResponse:
                return .none
            }
        }
    }
}
