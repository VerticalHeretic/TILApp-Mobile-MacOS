//
//  AcronymsView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct AcronymsView: View {
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
                    List(viewStore.searchResults) { acronym in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(acronym.short)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("by ") //TODO: Add user details here (need to study
                                    .font(.caption)
                            }
                            
                            Text(acronym.long)
                                .font(.caption)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.deleteAcronym(acronym.id.description))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                viewStore.send(.editAcronym(acronym))
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.accentColor)
                        }
                    }
                    .navigationTitle("Acronyms")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewStore.send(.createAcronym)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .navigationDestination(for: AcronymsFeature.State.Destination.self) { destination in
                        switch destination {
                        case .edit(let acronym):
                            Text(acronym.long)
                        case .create:
                            Text("Create")
                        }
                    }
                    
                    if viewStore.isLoading {
                        ProgressView()
                    }
                }
            }
            .onAppear {
                if viewStore.acronyms.isEmpty {
                    viewStore.send(.fetchAcronyms)
                }
            }
            .refreshable {
                viewStore.send(.fetchAcronyms)
            }
            .searchable(text: viewStore.binding(get: \.searchTerm,
                                                send: { .searchAcronyms($0)})
            )
        }
        
    }
}

struct AcronymsView_Previews: PreviewProvider {
    static var previews: some View {
        AcronymsView(store: Store(initialState: AcronymsFeature.State(),
                                  reducer: {
            AcronymsFeature()
        })
        )
    }
}
