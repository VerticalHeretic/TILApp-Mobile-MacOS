//
//  CategoriesView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 29/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct CategoriesView: View {
    let store: StoreOf<CategoriesFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(viewStore.categories) { category in
                Text(category.name)
            }
            .navigationTitle("Categories")
            .onAppear {
                if viewStore.categories.isEmpty {
                    viewStore.send(.fetchCategories)
                }
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(store: Store(initialState: CategoriesFeature.State(),
                                    reducer: {
            CategoriesFeature()
        }))
    }
}
