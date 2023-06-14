//
//  UsersFeature.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 27/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct UsersFeature: ReducerProtocol {
    
    struct State: Equatable {
        var alert: AlertState<Action>?
        var users: [UserResponse] = []
        var path = NavigationPath()
        var userState = UserFeature.State()
        var addUserProfilePictureState = AddUserProfilePictureFeature.State()
        @BindingState var error: String?
        @BindingState var isLoading = false
        
        enum Destination: Equatable, Hashable {
            case create
            case addProfilePhoto
        }
    }
    
    enum Action: Equatable, BindableAction {
        case copyButtonTapped(UserResponse)
        case copyButtonAlertDismissed
        case fetchUsers
        case createUser
        case addProfilePicture
        case deleteUser(String)
        case navigationPathChanged(NavigationPath)
        case user(UserFeature.Action)
        case profilePicture(AddUserProfilePictureFeature.Action)
        case binding(BindingAction<State>)
        
        case deleteResponse(String)
        case usersResponse([UserResponse])
        case errorResponse(String)
    }
    
    @Dependency(\.usersClient) var usersClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .copyButtonTapped(let user):
                let id = user.id.uuidString
                
#if os(macOS)
                NSPasteboard.general.setString(id, forType: .string) // TODO: Not working, need to add some capabilities for macOS sandbox I suppose. Will fix later.
#else
                UIPasteboard.general.string = id
                state.alert = AlertState {
                    TextState("Copied userID: \(id) 🙋🏻‍♀️")
                }
#endif
                return .none
            case .copyButtonAlertDismissed:
                state.alert = nil
                return .none
            case .fetchUsers:
                state.isLoading = true
                return .run { send in
                    do {
                        let users = try await self.usersClient.all()
                        await send(.usersResponse(users))
                    } catch {
                        await send(.errorResponse(error.localizedDescription))
                    }
                }
            case .deleteUser(let id):
                return .run { send in
                    do {
                        try await self.usersClient.delete(id)
                        await send(.deleteResponse(id))
                    } catch {
                        await send(.errorResponse(error.localizedDescription))
                    }
                }
            case .createUser:
                state.path.append(State.Destination.create)
                return .none
            case .addProfilePicture:
                state.path.append(State.Destination.addProfilePhoto)
                return .none
            case let .navigationPathChanged(path):
                state.path = path
                return .none
            case .deleteResponse(let id):
                state.users.removeAll(where: { $0.id.uuidString == id })
                return .none
            case .usersResponse(let users):
                state.error = nil
                state.users = users
                state.isLoading = false
                return .none
            case .errorResponse(let errorMessage):
                state.isLoading = false
                state.error = errorMessage
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.addUserProfilePictureState, action: /Action.profilePicture) {
            AddUserProfilePictureFeature()
        }
        
        Scope(state: \.userState, action: /Action.user) {
            UserFeature()
        }
    }
}
