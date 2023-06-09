//
//  LoadingModifier.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 09/06/2023.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .overlay {
                        ProgressView()
                            .tint(Color.accentColor)
                    }
            }
        }
    }
}

extension View {
    func loadable(isLoading: Binding<Bool>) -> some View {
        return modifier(LoadingModifier(isLoading: isLoading))
    }
}
