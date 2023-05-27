//
//  AcronymsFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import Foundation
import ComposableArchitecture

struct AcronymsFeature: ReducerProtocol {
    
    struct State: Equatable {
        var isLoading = false
        var acronyms: [AcronymResponse] = []
    }
    
    enum Action: Equatable {
        case fetchAcronyms
        case acronymsResponse([AcronymResponse])
    }
    
    @Dependency(\.acronymsClient) var acronymClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchAcronyms:
            state.isLoading = true
            return .run { send in
                try await send(.acronymsResponse(self.acronymClient.all()))
            }
        case .acronymsResponse(let acronyms):
            state.acronyms = acronyms
            state.isLoading = false
            return .none
        }
    }
}
