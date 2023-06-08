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
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: CategoriesFeature.Action.navigationPathChanged)) {
                        List(viewStore.categories) { category in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(category.name)
                                Text(category.id.uuidString)
                                    .font(.caption)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewStore.send(.deleteCategory(category.id.uuidString))
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                viewStore.send(.copyButtonTapped(category))
                            }
                        }
                        .navigationTitle("Categories")
                        .toolbar {
                            #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    viewStore.send(.createCategory)
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                            #endif
                        }
                        .onAppear {
                            if viewStore.categories.isEmpty {
                                viewStore.send(.fetchCategories)
                            }
                        }
                        .refreshable {
                            viewStore.send(.fetchCategories)
                        }
                        .navigationDestination(for: CategoriesFeature.State.Destination.self) { destination in
                            switch destination {
                            case .create:
                                CategoryForm(store: self.store.scope(state: \.categoryState,
                                                                     action: CategoriesFeature.Action.category))
                            }
                        }
                        .alert(
                            self.store.scope(state: \.alert, action: { $0 }),
                            dismiss: .copyButtonAlertDismissed
                        )
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
