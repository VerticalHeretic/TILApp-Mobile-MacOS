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
            VStack {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    List(viewStore.acronyms) { acronym in
                        Text(acronym.long)
                    }
                }
            }
            .task {
                viewStore.send(.fetchAcronyms)
            }
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
