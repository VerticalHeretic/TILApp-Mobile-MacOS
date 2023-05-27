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
        var searchTerm = ""
        
        var searchResults: [AcronymResponse] {
            if searchTerm.isEmpty {
                return acronyms
            } else {
                return acronyms.filter {
                    $0.long.lowercased().contains(searchTerm.lowercased()) ||
                    $0.short.lowercased().contains(searchTerm.lowercased())
                }
            }
        }
    }
    
    enum Action: Equatable {
        case fetchAcronyms
        case acronymsResponse([AcronymResponse])
        case searchAcronyms(String)
    }
    
    @Dependency(\.acronymsClient) var acronymClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchAcronyms:
            state.isLoading = true
            return .run { send in
                try await send(.acronymsResponse(self.acronymClient.all()))
            }
        case .searchAcronyms(let term):
            state.searchTerm = term
            return .none
        case .acronymsResponse(let acronyms):
            state.acronyms = acronyms
            state.isLoading = false
            return .none
        }
    }
}
