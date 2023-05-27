//
//  UsersFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import Foundation
import ComposableArchitecture

struct UsersFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = false
        var users: [UserResponse] = []
    }
    
    enum Action: Equatable {
        case fetchUsers
        case usersResponse([UserResponse])
    }
    
    @Dependency(\.usersClient) var usersClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchUsers:
            state.isLoading = true
            return .run { send in
                try await send(.usersResponse(self.usersClient.all()))
            }
        case .usersResponse(let users):
            state.users = users
            state.isLoading = false
            return .none
        }
    }
}
