//
//  CategoriesViewMac.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 06/06/2023.
//

import SwiftUI
import ComposableArchitecture

struct CategoriesViewMac: View {
    let store: StoreOf<CategoriesFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: CategoriesFeature.Action.navigationPathChanged)) {
                        Table(viewStore.categories) {
                            TableColumn("Name") { category in
                                Text(category.name)
                                    .contextMenu {
                                        buildContextMenu(viewStore: viewStore, category: category)
                                    }
                            }
                            
                            TableColumn("UUID") { category in
                                Text(category.id.uuidString)
                                    .contextMenu {
                                       buildContextMenu(viewStore: viewStore, category: category)
                                    }
                            }
                        }
                        .navigationTitle("Categories")
                        .loadable(isLoading: viewStore.binding(\.$isLoading))
                        .errorable(error: viewStore.binding(\.$error))
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    viewStore.send(.createCategory)
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .keyboardShortcut("n")
                            }
                            
                            ToolbarItem {
                                Button {
                                    viewStore.send(.fetchCategories)
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                }
                                .keyboardShortcut("r")
                            }
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
    
    func buildContextMenu(viewStore: ViewStoreOf<CategoriesFeature>, category: CategoryResponse) -> some View {
        VStack {
            Button {
                viewStore.send(.deleteCategory(category.id.uuidString))
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                viewStore.send(.copyButtonTapped(category))
            } label: {
                Label("Copy", systemImage: "doc.on.clipboard.fill")
            }
        }
    }
}

struct CategoriesViewMac_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesViewMac(store: Store(initialState: CategoriesFeature.State(),
                                       reducer: {
            CategoriesFeature()
        }))
    }
}
