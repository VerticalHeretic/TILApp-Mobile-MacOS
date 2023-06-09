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
                Table(viewStore.searchResults, sortOrder: viewStore.binding(\.$sortOrder)) {
                    TableColumn("Short", value: \.short) { acronym in
                        Text(acronym.short)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, acronym: acronym)
                            }
                    }
                    .width(min: 50, ideal: 100, max: 100)
                    
                    TableColumn("Long", value: \.long) { acronym in
                        Text(acronym.long)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, acronym: acronym)
                            }
                    }
                    
                    TableColumn("Created by", value: \.user.username) { acronym in
                        Text(acronym.user.username)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, acronym: acronym)
                            }
                    }
                }
                .searchable(text: viewStore.binding(get: \.searchTerm,
                                                    send: { .searchAcronyms($0)})
                )
                .navigationTitle("Acronyms")
                .loadable(isLoading: viewStore.binding(\.$isLoading))
                .errorable(error: viewStore.binding(\.$error))
                .toolbar(id: "acronyms_toolbar") {
                    ToolbarItem(id: "createAcronym_button") {
                        Button {
                            viewStore.send(.createAcronym)
                        } label: {
                            Image(systemName: "plus")
                        }
                        .keyboardShortcut("n")
                    }
                    
                    ToolbarItem(id: "fetchAcronyms_button") {
                        Button {
                            viewStore.send(.fetchAcronyms)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .keyboardShortcut("r")
                    }
                    
                    ToolbarItem(id: "logout_button") {
                        Button {
                            viewStore.send(.logout)
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .keyboardShortcut("q")
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
                .onAppear {
                    if viewStore.acronyms.isEmpty {
                        viewStore.send(.fetchAcronyms)
                    }
                }
            }
        }
    }
    
    func buildContextMenu(viewStore: ViewStoreOf<AcronymsFeature>, acronym: AcronymResponse) -> some View {
        VStack {
            Button {
                viewStore.send(.deleteAcronym(acronym.id.uuidString))
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                viewStore.send(.editAcronym(acronym))
            } label: {
                Label("Edit", systemImage: "pencil")
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
