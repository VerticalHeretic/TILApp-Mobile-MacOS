//
//  LoginView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 01/06/2023.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                TextField("Username", text: viewStore.binding(\.$username))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)
                
                SecureField("Password", text: viewStore.binding(\.$password))
                
                Button("Login") {
                    Task {
                        await viewStore.send(.loginTapped).finish()
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: Store(initialState: LoginFeature.State(),
                               reducer: {
            LoginFeature()
        }))
    }
}
