//
//  ContentView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject var store: StoreOf<ContentFeature>

    var body: some View {
        WithViewStore(store, observe: \.screen) { viewStore in
            switch viewStore.state {
            case .registration:
                SignInView(store: store.scope(state: \.registration, action: \.registration))
            case .mainTabBar:
                MainTabBarView(store: store.scope(state: \.mainTabBar, action: \.mainTabBar))
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: ContentFeature.State(), reducer: { ContentFeature() }))
        .modelContainer(for: Item.self, inMemory: true)
}
