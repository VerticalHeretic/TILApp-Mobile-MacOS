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
            observe: { (selectedTab: $0.selectedTab, acronymsCount: $0.acronyms.acronyms.count, isAuthenthicated: $0.isAuthenthicated) },
            removeDuplicates: ==
        ) { viewStore in
            if viewStore.isAuthenthicated {
                #if os(iOS)
                buildiOSUI(viewStore: viewStore)
                #else
                buildMacUI(viewStore: viewStore)
                #endif
            } else {
                LoginView(store: self.store.scope(state: \.loginState,
                                                  action: Root.Action.login))
            }
        }
    }
    
    @ViewBuilder private func buildMacUI(viewStore: ViewStore<(selectedTab: Root.State.Tab, acronymsCount: Int, isAuthenthicated: Bool), Root.Action>) -> some View {
        NavigationSplitView {
            #if os(macOS)
            List(Root.State.Tab.allCases, selection: viewStore.binding(get: \.selectedTab, send: Root.Action.selectedTabChange)) { tab in
                NavigationLink(tab.rawValue, value: tab)
                    .badge(
                        tab == .acronyms ? viewStore.state.acronymsCount : 0
                    )
            }
            #endif
        } detail: {
            switch viewStore.state.selectedTab {
            case .acronyms:
                buildAcronymsView(viewStore: viewStore)
            case .users:
                buildUsersView(viewStore: viewStore)
            case .categories:
                buildCategoriesView(viewStore: viewStore)
            }
        }
        .frame(minWidth: 700,
               idealWidth: 1000,
               maxWidth: .infinity,
               minHeight: 400,
               idealHeight: 800,
               maxHeight: .infinity)
    }
    
    @ViewBuilder private func buildiOSUI(viewStore: ViewStore<(selectedTab: Root.State.Tab, acronymsCount: Int, isAuthenthicated: Bool), Root.Action>) -> some View {
        TabView(selection: viewStore.binding(get: \.selectedTab, send: Root.Action.selectedTabChange)) {
            buildAcronymsView(viewStore: viewStore)
            buildUsersView(viewStore: viewStore)
            buildCategoriesView(viewStore: viewStore)
        }
    }
    
    @ViewBuilder private func buildAcronymsView(viewStore: ViewStore<(selectedTab: Root.State.Tab, acronymsCount: Int, isAuthenthicated: Bool), Root.Action>) -> some View {
        #if os(iOS)
        AcronymsView(store: self.store.scope(state: \.acronyms,
                                             action: Root.Action.acronyms))
        .tag(Root.State.Tab.acronyms)
        .tabItem {
            Label("Acronyms", systemImage: "text.quote")
        }
        .badge(viewStore.state.acronymsCount)
        #else
        AcronymsViewMac(store: self.store.scope(state: \.acronyms,
                                                action: Root.Action.acronyms))
        .tag(Root.State.Tab.acronyms)
        #endif
    }
    
    @ViewBuilder private func buildUsersView(viewStore: ViewStore<(selectedTab: Root.State.Tab, acronymsCount: Int, isAuthenthicated: Bool), Root.Action>) -> some View {
        UsersView(store: self.store.scope(state: \.users,
                                          action: Root.Action.users))
        .tag(Root.State.Tab.users)
        .tabItem {
            Label("Users", systemImage: "person.fill")
        }
    }
    
    @ViewBuilder private func buildCategoriesView(viewStore: ViewStore<(selectedTab: Root.State.Tab, acronymsCount: Int, isAuthenthicated: Bool), Root.Action>) -> some View {
        CategoriesView(store: self.store.scope(state: \.categories,
                                               action: Root.Action.categories))
        .tag(Root.State.Tab.categories)
        .tabItem {
            Label("Categories", systemImage: "tag.fill")
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
