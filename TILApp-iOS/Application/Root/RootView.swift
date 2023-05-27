//
//  MainView.swift
//  TILApp-iOS
//
//  Created by Łukasz Stachnik on 26/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<Root>
    
    var body: some View {
        WithViewStore(
            store,
            observe: { (selectedTab: $0.selectedTab, acronymsCount: $0.acronyms.acronyms.count) },
            removeDuplicates: ==
        ) { viewStore in
            TabView(selection: viewStore.binding(get: \.selectedTab, send: Root.Action.selectedTabChange)) {
                AcronymsView(store: self.store.scope(state: \.acronyms,
                                                     action: Root.Action.acronyms))
                .tag(Root.State.Tab.acronyms)
                .tabItem {
                    Label("Acronyms", systemImage: "text.quote")
                }
                .badge(viewStore.state.acronymsCount)
                
                UsersView(store: self.store.scope(state: \.users,
                                                  action: Root.Action.users))
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
        RootView(
            store: Store(initialState: Root.State(),
                         reducer: {
                             Root()
                         })
        )
    }
}
