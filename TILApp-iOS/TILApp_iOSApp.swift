//
//  TILApp_iOSApp.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 25/05/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TILApp_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: CounterFeature.State(),
                             reducer: {
                                 CounterFeature()
                                     ._printChanges()
                             }))
        }
    }
}
