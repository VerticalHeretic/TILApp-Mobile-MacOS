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
            NavigationStack {
                ZStack {
                    List(viewStore.searchResults) { acronym in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(acronym.short)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("by ")
                                    .font(.caption)
                            }
                          
                            Text(acronym.long)
                                .font(.caption)
                        }
                        
                    }
                    .navigationTitle("Acronyms")
                    
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
        AcronymsView(
            store: Store(initialState: AcronymsFeature.State(),
                         reducer: {
                             AcronymsFeature()
                         })
        )
    }
}
