//
//  AddUserProfilePictureView.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 13/06/2023.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct AddUserProfilePictureView: View {
    let store: StoreOf<AddUserProfilePictureFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                PhotosPicker("Select Profile Picture", selection: viewStore.binding(\.$userItem), matching: .images)
                
                if let data = viewStore.state.userImage, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    Button("Save") {
                        viewStore.send(.saveTapped)
                        dismiss()
                    }
                    .frame(width: 120, height: 80, alignment: .center)
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                }
            }
            .loadable(isLoading: viewStore.binding(\.$isLoading))
            .errorable(error: viewStore.binding(\.$error))
            .onChange(of: viewStore.state.userItem) { item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self) {
                        viewStore.send(.imageLoaded(data))
                    }
                }
            }
        }
    }
}

struct AddUserProfilePictureView_Preview: PreviewProvider {
    static var previews: some View {
        AddUserProfilePictureView(store: Store(initialState: AddUserProfilePictureFeature.State(), reducer: {
            AddUserProfilePictureFeature()
        }))
    }
}
