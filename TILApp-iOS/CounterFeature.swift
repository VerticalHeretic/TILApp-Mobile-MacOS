//
//  CounterFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 25/05/2023.
//

import ComposableArchitecture
import Foundation

struct CounterFeature: ReducerProtocol {

    struct State: Equatable {
        var count = 0
        var isLoading = false
        var fact: String?
        var acronyms: [AcronymResponse] = []
        var acronym: AcronymResponse?
        var isTimerRunning = false
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case acronymsButtonTapped
        case createAcronymButtonTapped
        case acronymsResponse([AcronymResponse])
        case acronymResponse(AcronymResponse)
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFactClient
    @Dependency(\.acronymsClient) var acronymClient

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none
        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none
        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none
            
        case .factButtonTapped:
            state.isLoading = true
            state.fact = nil
            return .run { [count = state.count] send in
                try await send(.factResponse(self.numberFactClient.fetch(count)))
            }
        case .factResponse(let fact):
            state.fact = fact
            state.isLoading = false
            return .none
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }
        case .acronymsButtonTapped:
            state.fact = nil
            state.acronym = nil
            state.isLoading = true
            return .run { send in
                try await send(.acronymsResponse(self.acronymClient.all()))
            }
        case .createAcronymButtonTapped:
            state.fact = nil
            state.acronyms = []
            state.isLoading = true
            return .run { send in
                try await send(.acronymResponse(self.acronymClient.create(AcronymRequest(short: "WTFM", long: "What The Fuck Motherfucke", userID: "D319FF51-984F-4B90-8723-65D50DE5625F"))))
            }
        case .acronymsResponse(let acronyms):
            state.isLoading = false
            state.acronyms = acronyms
            return .none
        case .acronymResponse(let acronym):
            state.isLoading = false
            state.acronym = acronym
            return .none
        }
    }
}
