//
//  CategoryForm.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 30/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct CategoryForm: View {
    let store: StoreOf<CategoryFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Category Name", text: viewStore.binding(\.$name))
                
                Button("Save") {
                    Task {
                        await viewStore.send(.saveTapped).finish()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryForm_Previews: PreviewProvider {
    static var previews: some View {
        CategoryForm(store: Store(initialState: CategoryFeature.State(),
                                  reducer: {
            CategoryFeature()
        }))
    }
}
