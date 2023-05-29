//
//  AcronymForm.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 28/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct AcronymForm: View {
    let store: StoreOf<AcronymFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Acronym's Short Name", text: viewStore.binding(\.$short))
                    .autocorrectionDisabled()
                TextField("Acronym's Long Name", text: viewStore.binding(\.$long))
                TextField("Users ID", text: viewStore.binding(\.$userID))
                
                Button("Save"){
                    Task {
                        await viewStore.send(.saveTapped).finish()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AcronymForm_Previews: PreviewProvider {
    static var previews: some View {
        AcronymForm(store: Store(initialState: AcronymFeature.State(),
                                 reducer: {
            AcronymFeature()
        }))
    }
}
