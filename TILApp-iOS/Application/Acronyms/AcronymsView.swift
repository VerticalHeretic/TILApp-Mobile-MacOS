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
                                Text("by")
                                Text(acronym.user.username)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.accentColor)
                            }
                            
                            Text(acronym.long)
                                .font(.caption)
                            
                            ForEach(acronym.categories) { category in
                                Text(category.name)
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.deleteAcronym(acronym.id.uuidString))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                viewStore.send(.editAcronym(acronym))
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.accentColor)
                            
                            Button {
                                viewStore.send(.addCategory(acronym.id.uuidString))
                            } label: {
                                Label("Add Category", systemImage: "tag.fill")
                            }
                            .tint(Color.green)
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
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                viewStore.send(.logout)
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
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
