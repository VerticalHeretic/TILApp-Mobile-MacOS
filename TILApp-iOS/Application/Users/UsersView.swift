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
            }
            .navigationTitle("Users")
            .onAppear {
                if viewStore.users.isEmpty {
                    viewStore.send(.fetchUsers)
                }
            }
            .alert(
                self.store.scope(state: \.alert, action: { $0 }),
                dismiss: .copyButtonAlertDismissed
            )
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
