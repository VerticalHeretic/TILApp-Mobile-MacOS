//
//  AcronymsViewMac.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 05/06/2023.
//

import SwiftUI
import ComposableArchitecture

struct AcronymsViewMac: View {
    let store: StoreOf<AcronymsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: AcronymsFeature.Action.navigationPathChanged
                )
            ) {
                ZStack {
                    Table(viewStore.searchResults, sortOrder: viewStore.binding(\.$sortOrder)) {
                        TableColumn("Short", value: \.short) {
                            Text($0.short)
                        }
                        .width(min: 50, ideal: 100, max: 100)
                        
                        TableColumn("Long", value: \.long) {
                            Text($0.long)
                        }
                        
                        TableColumn("Created by", value: \.user.username) {
                            Text($0.user.username)
                        }
                    }
                    .navigationTitle("Acronyms")
                    .toolbar {
                        ToolbarItem {
                            Button {
                                viewStore.send(.createAcronym)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        
                        ToolbarItem {
                            Button {
                                viewStore.send(.logout)
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                }
                .navigationDestination(for: AcronymsFeature.State.Destination.self) { destination in
                    switch destination {
                    case .edit:
                        AcronymForm(store: self.store.scope(state: \.acronymState,
                                                            action: AcronymsFeature.Action.acronym))
                    case .create:
                        AcronymForm(store: self.store.scope(state: \.acronymState,
                                                            action: AcronymsFeature.Action.acronym))
                    }
                }
                
                if viewStore.isLoading {
                    ProgressView()
                }
            }
            .onAppear {
                if viewStore.acronyms.isEmpty {
                    viewStore.send(.fetchAcronyms)
                }
            }
        }
    }
}



struct AcronymsViewMac_Previews: PreviewProvider {
    static var previews: some View {
        AcronymsView(store: Store(initialState: AcronymsFeature.State(),
                                  reducer: {
            AcronymsFeature()
        })
        )
    }
}
