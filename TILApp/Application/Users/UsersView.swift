//
//  UsersView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct UsersView: View {
    let store: StoreOf<UsersFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: UsersFeature.Action.navigationPathChanged)
            ) {
                List(viewStore.users) { user in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(user.name)
                                .font(.headline)
                            Text("-")
                                .font(.headline)
                            Text(user.username)
                                .font(.headline)
                        }
                        Text(user.id.uuidString)
                            .font(.caption)
                    }
                    .onTapGesture {
                        viewStore.send(.copyButtonTapped(user))
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.deleteUser(user.id.uuidString))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.createUser)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    #endif
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
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(store: Store(initialState: UsersFeature.State(),
                               reducer: {
            UsersFeature()
        }))
    }
}
