//
//  AcronymsFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct AcronymsState: Equatable {
    var isLoading = false
    var acronyms: [AcronymResponse] = []
    var path = NavigationPath()
    var searchTerm = ""
    var acronymState = AcronymFeature.State()
    @BindingState var sortOrder = [KeyPathComparator(\AcronymResponse.long)]
    
    enum Destination: Equatable, Hashable {
        case edit
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

struct AcronymsFeature: ReducerProtocol {
    
    typealias State = AcronymsState
    
    enum Action: Equatable, BindableAction {
        case fetchAcronyms
        case searchAcronyms(String)
        case deleteAcronym(String)
        case editAcronym(AcronymResponse)
        case createAcronym
        case addCategory(_ acronymId: String)
        case categoryAdded
        case navigationPathChanged(NavigationPath)
        case binding(BindingAction<State>)
        case acronym(AcronymFeature.Action)
        case logout
        
        case acronymsResponse([AcronymResponse])
        case deleteResponse(String)
    }
    
    @Dependency(\.acronymsClient) var acronymClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$sortOrder):
                state.acronyms.sort(using: state.sortOrder)
                return .none
            case .acronym(.acronymResponse(let acronym)):
                state.acronyms.append(acronym)
                return .none
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
            case .searchAcronyms(let term):
                state.searchTerm = term
                return .none
            case .editAcronym(let acronym):
                state.acronymState = AcronymState(acronym: acronym)
                state.path.append(State.Destination.edit)
                return .none
            case .createAcronym:
                state.acronymState = AcronymState()
                state.path.append(State.Destination.create)
                return .none
            case .addCategory(let acronymID):
                state.isLoading = true
                return .run { send in
                    #if os(macOS)
                    guard let categoryID = NSPasteboard.general.string(forType: .string) else { return }
                    try await self.acronymClient.addCategory(acronymID, categoryID)
                    await send(.categoryAdded)
                    #else
                    guard let categoryID = UIPasteboard.general.string else { return }
                    try await self.acronymClient.addCategory(acronymID, categoryID)
                    await send(.categoryAdded)
                    #endif
                }
            case .categoryAdded:
                state.isLoading = false
                return .none
            case let .navigationPathChanged(path):
                state.path = path
                return .none
            case .acronymsResponse(let acronyms):
                state.acronyms = acronyms
                state.isLoading = false
                return .none
            case .deleteResponse(let id):
                state.acronyms.removeAll(where: { $0.id.uuidString == id })
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.acronymState, action: /Action.acronym) {
            AcronymFeature()
        }
    }
}
