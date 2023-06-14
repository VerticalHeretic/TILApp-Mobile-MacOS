//
//  UserForm.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 30/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct UserForm: View {
    let store: StoreOf<UserFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form(content: {
                TextField("User's name", text: viewStore.binding(\.$name))
                TextField("User's username", text: viewStore.binding(\.$username))
                    .textContentType(.username)
                SecureField("User's password", text: viewStore.binding(\.$password))
                    .textContentType(.newPassword)
                
                Button("Save") {
                    Task {
                        await viewStore.send(.saveTapped).finish()
                        dismiss()
                    }
                }
            })
        }
    }
}

struct UserForm_Previews: PreviewProvider {
    static var previews: some View {
        UserForm(store: Store(initialState: UserFeature.State(),
                              reducer: {
            UserFeature()
        }))
    }
}
