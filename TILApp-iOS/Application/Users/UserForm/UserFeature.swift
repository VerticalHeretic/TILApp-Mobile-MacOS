//
//  UserFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 30/05/2023.
//

import Foundation
import ComposableArchitecture

struct UserState: Equatable {
    @BindingState var name: String = ""
    @BindingState var username: String = ""
}

struct UserFeature: ReducerProtocol {
    
    typealias State = UserState
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveTapped
        case userResponse(UserResponse)
    }
    
    @Dependency(\.usersClient) var usersClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveTapped:
                return .run { [name = state.name, username = state.username] send in
                    let request = UserRequest(name: name, username: username)
                    
                    try await send(.userResponse(self.usersClient.create(request)))
                }
            case .userResponse(let user):
                return .none
            }
        }
    }
}
