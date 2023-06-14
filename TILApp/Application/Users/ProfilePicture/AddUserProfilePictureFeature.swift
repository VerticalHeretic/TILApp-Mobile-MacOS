//
//  AddUserProfilePictureFeature.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 13/06/2023.
//

import ComposableArchitecture
import PhotosUI
import SwiftUI

struct AddUserProfilePictureState: Equatable {
    @BindingState var userItem: PhotosPickerItem?
    @BindingState var userImage: Data?
    @BindingState var error: String?
    @BindingState var isLoading = false
}

struct AddUserProfilePictureFeature: ReducerProtocol {
    
    typealias State = AddUserProfilePictureState
    
    enum Action: BindableAction, Equatable {
        case saveTapped
        case imageLoaded(_ image: Data)
        case binding(BindingAction<State>)
        
        case imageResponse
        case errorResponse(String)
    }
    
    @Dependency(\.usersClient) var usersClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .saveTapped:
                state.error = nil
                state.isLoading = true
                return .run { [image = state.userImage] send in
                    do {
                        guard let image = image else { return }
                        try await self.usersClient.addProfilePicture(ImageUploadData(picture: image))
                        await send(.imageResponse)
                    } catch {
                        await send(.errorResponse(error.localizedDescription))
                    }
                }
            case .imageLoaded(let image):
                state.userImage = image
                return .none
            case .errorResponse(let errorMessage):
                state.isLoading = false
                state.error = errorMessage
                return .none
            case .imageResponse:
                state.isLoading = false
                return .none
            }
        }
    }
}
