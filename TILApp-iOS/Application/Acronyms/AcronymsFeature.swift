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
        var path: [Destination] = []
        var searchTerm = ""
        
        enum Destination: Equatable, Hashable {
            case edit(AcronymResponse)
            case create
        }
        
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
        case deleteAcronym(String)
        case deleteResponse(String)
        case editAcronym(AcronymResponse)
        case createAcronym
        case navigationPathChanged([State.Destination])
    }
    
    @Dependency(\.acronymsClient) var acronymClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAcronyms:
                state.isLoading = true
                return .run { send in
                    try await send(.acronymsResponse(self.acronymClient.all()))
                }
            case .deleteAcronym(let id):
                return .run { send in
                    try await self.acronymClient.delete(id)
                    await send(.deleteResponse(id))
                }
            case .deleteResponse(let id):
                state.acronyms.removeAll(where: { $0.id.description == id })
                return .none
            case .searchAcronyms(let term):
                state.searchTerm = term
                return .none
            case .acronymsResponse(let acronyms):
                state.acronyms = acronyms
                state.isLoading = false
                return .none
            case .editAcronym(let acronym):
                state.path.append(.edit(acronym))
                return .none
            case .createAcronym:
                state.path.append(.create)
                return .none
            case let .navigationPathChanged(path):
                state.path = path
                return .none
            }
        }
    }
}
