//
//  AcronymFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 28/05/2023.
//

import Foundation
import ComposableArchitecture

struct AcronymState: Equatable {
    @BindingState var isLoading = false
    @BindingState var short: String = ""
    @BindingState var long: String = ""
    @BindingState var userID: String = ""
    
    var acronym: AcronymResponse?
}

extension AcronymState {
    init(acronym: AcronymResponse) {
        self.long = acronym.long
        self.short = acronym.short
        self.userID = acronym.user.id.uuidString
        self.acronym = acronym
    }
}

struct AcronymFeature: ReducerProtocol {
    
    typealias State = AcronymState
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveTapped
        case acronymResponse(AcronymResponse)
    }
    
    @Dependency(\.acronymsClient) var acronymClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveTapped:
                return .run { [short = state.short, long = state.long, userID = state.userID, acronym = state.acronym] send in
                    let request = AcronymRequest(
                        short: short,
                        long: long,
                        userID: userID
                    )
                    
                    if let acronym {
                        try await send(.acronymResponse(self.acronymClient.update(acronym.id.uuidString, request)))
                    } else {
                        try await send(.acronymResponse(self.acronymClient.create(request)))
                    }
                }
            case .acronymResponse(let acronym):
                return .none 
            }
        }
    }
}
