//
//  MainView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<Root>
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(send: Root.Action.selectedTabChange)) {
                AcronymsView(store: self.store.scope(state: \.acronyms,
                                                     action: Root.Action.acronyms))
                    .tag(Root.State.Tab.acronyms)
                    .tabItem {
                        Label("Acronyms", systemImage: "text.quote")
                    }
                Text("Users")
                    .tag(Root.State.Tab.users)
                    .tabItem {
                        Label("Users", systemImage: "person.fill")
                    }
                Text("Categories")
                    .tag(Root.State.Tab.categories)
                    .tabItem {
                        Label("Categories", systemImage: "tag.fill")
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(initialState: Root.State(),
                         reducer: {
                             Root()
                         })
        )
    }
}
