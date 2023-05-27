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
            RootView(store: Store(initialState: Root.State(),
                                  reducer: {
                Root()
                    ._printChanges()
            }))
        }
    }
}
