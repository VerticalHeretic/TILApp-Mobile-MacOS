//
//  LoginView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 01/06/2023.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack(alignment: .center) {
                    #if os(iOS)
                    TextField("Username", text: viewStore.binding(\.$username))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textContentType(.username)
                        .frame(minWidth: 100, maxWidth: 250)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: viewStore.binding(\.$password))
                        .frame(minWidth: 100, maxWidth: 250)
                        .textFieldStyle(.roundedBorder)
                    #else
                    TextField("Username", text: viewStore.binding(\.$username))
                        .autocorrectionDisabled()
                    SecureField("Password", text: viewStore.binding(\.$password))
                        
                    #endif
                    Button("LOGIN") {
                        Task {
                            await viewStore.send(.loginTapped).finish()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    HStack(spacing: 24) {
                        Image("GoogleNormal")
                            .frame(width: 18, height: 18)
                        Text("SIGN IN WITH GOOGLE")
                            .foregroundColor(Color.black.opacity(0.54))
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 40)
                    .background(Color("GoogleColor"))
                    .onTapGesture {
                        Task {
                            try await logInWithGoogle(viewStore: viewStore)
                        }
                    }
                }
                .navigationTitle("Sign In")
            }
        }
    }
    
    @MainActor func logInWithGoogle(viewStore: ViewStore<LoginFeature.State, LoginFeature.Action>) async throws {
        guard let googleAuthURL = URL(string: "http://localhost:8080/iOS/login-google") else {
            return
        }
        
        let scheme = "tilapp"
        let result = try await webAuthenticationSession.authenticate(using: googleAuthURL, callbackURLScheme: scheme)
        let token = result.queryParameters?["token"]
        Auth.shared.token = token
        viewStore.send(.loginResponse)
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
