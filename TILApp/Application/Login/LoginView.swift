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
                        Image(.googleNormal)
                            .resizable()
                            .frame(width: 24, height: 24)
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
                    
                    HStack(spacing: 24) {
                        Image(.github)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("SIGN IN WITH GITHUB")
                            .foregroundColor(Color.black.opacity(0.54))
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 40)
                    .background(Color.accentColor)
                    .onTapGesture {
                        Task {
                            try await logInWithGithub(viewStore: viewStore)
                        }
                    }
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        Task {
                            try await handleSignInWithAppleIDResult(result, viewStore: viewStore)
                        }
                    }
                    .frame(width: 140, height: 40)
                }
                .navigationTitle("Sign In")
            }
        }
    }
    
    @MainActor func logInWithGoogle(viewStore: ViewStoreOf<LoginFeature>) async throws {
        guard let googleAuthURL = URL(string: "http://localhost:8080/iOS/login-google") else {
            return
        }
        
        let scheme = "tilapp"
        let result = try await webAuthenticationSession.authenticate(using: googleAuthURL, callbackURLScheme: scheme)
        let token = result.queryParameters?["token"]
        Auth.shared.token = token
        viewStore.send(.loginResponse)
    }
    
    @MainActor func logInWithGithub(viewStore: ViewStoreOf<LoginFeature>) async throws {
        guard let githubAuthURL = URL(string: "http://localhost:8080/iOS/login-github") else {
            return
        }
        
        let scheme = "tilapp"
        let result = try await webAuthenticationSession.authenticate(using: githubAuthURL, callbackURLScheme: scheme)
        let token = result.queryParameters?["token"]
        Auth.shared.token = token
        viewStore.send(.loginResponse)
    }

    @MainActor func handleSignInWithAppleIDResult(_ result: Result<ASAuthorization, Error>, viewStore: ViewStoreOf<LoginFeature>) async throws {
        switch result {
        case .success(let success):
            guard let credential = success.credential as? ASAuthorizationAppleIDCredential,
                  let identityToken = credential.identityToken,
                  let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                return // TODO: Add handling o the error
            }
            
            let name: String?
            if let nameProvided = credential.fullName {
                let firstName = nameProvided.givenName ?? ""
                let lastName = nameProvided.familyName ?? ""
                name = "\(firstName) \(lastName)"
            } else {
                name = nil
            }
            
            try await Auth.shared.login(signInWithAppleToken: .init(token: identityTokenString, name: name))
            viewStore.send(.loginResponse)
        case .failure(let failure):
            break
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
