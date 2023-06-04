//
//  AcronymFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 28/05/2023.
//

import Foundation
import ComposableArchitecture

struct AcronymState: Equatable, Hashable {
    @BindingState var isLoading = false
    @BindingState var short: String = ""
    @BindingState var long: String = ""
    
    var acronym: AcronymResponse?
}

extension AcronymState {
    init(acronym: AcronymResponse) {
        self.long = acronym.long
        self.short = acronym.short
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
                return .run { [short = state.short, long = state.long, acronym = state.acronym] send in
                    let request = AcronymRequest(
                        short: short,
                        long: long
                    )
                    
                    do {
                        if let acronym {
                            try await send(.acronymResponse(self.acronymClient.update(acronym.id.uuidString, request)))
                        } else {
                            try await send(.acronymResponse(self.acronymClient.create(request)))
                        }
                    } catch {
                        debugPrint(error)
                    }
                }
            case .acronymResponse:
                return .none 
            }
        }
    }
}
