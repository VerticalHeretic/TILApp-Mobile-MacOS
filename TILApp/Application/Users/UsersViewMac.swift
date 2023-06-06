//
//  UsersViewMac.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 06/06/2023.
//

import SwiftUI
import ComposableArchitecture

struct UsersViewMac: View {
    let store: StoreOf<UsersFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: UsersFeature.Action.navigationPathChanged)
            ) {
                Table(viewStore.users) {
                    TableColumn("Name") { user in
                        Text(user.name)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, user: user)
                            }
                    }
                    
                    TableColumn("Username") { user in
                        Text(user.username)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, user: user)
                            }
                    }
                    
                    TableColumn("UUID") { user in 
                        Text(user.id.uuidString)
                            .contextMenu {
                                buildContextMenu(viewStore: viewStore, user: user)
                            }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.createUser)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationDestination(for: UsersFeature.State.Destination.self) { destination in
                    switch destination {
                    case .create:
                        UserForm(store: Store(initialState: UserState(), reducer: {
                            UserFeature()
                        }))
                    }
                }
                .onAppear {
                    if viewStore.users.isEmpty {
                        viewStore.send(.fetchUsers)
                    }
                }
                .alert(
                    self.store.scope(state: \.alert, action: { $0 }),
                    dismiss: .copyButtonAlertDismissed
                )
                .refreshable {
                    viewStore.send(.fetchUsers)
                }
            }
        }
    }
    
    func buildContextMenu(viewStore: ViewStoreOf<UsersFeature>, user: UserResponse) -> some View {
        VStack {
            Button {
                viewStore.send(.copyButtonTapped(user))
            } label: {
                Label("Copy", systemImage: "doc.on.clipboard.fill")
            }
            
            Button {
                viewStore.send(.deleteUser(user.id.uuidString))
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct UsersViewMac_Previews: PreviewProvider {
    static var previews: some View {
        UsersViewMac(store: Store(initialState: .init(), reducer: { UsersFeature() }))
    }
}
