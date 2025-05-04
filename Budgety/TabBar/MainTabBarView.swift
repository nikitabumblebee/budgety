//
//  MainTabBarView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct MainTabBarView: View {
    enum Constants {
        static let titleColor = Color(red: 0.117, green: 0.226, blue: 0.54)
    }

    @Bindable var store: StoreOf<MainTabBarReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0.selectedTab },
                send: { .tabSelected($0) }
            )) {
                IncomeAndSpendingsView(
                    store: store.scope(state: \.incomeAndSpendings, action: \.incomeAndSpendings)
                )
                .tabItem {
                    Label("Main", systemImage: "house.fill")
                }
                .tag(MainTabBarReducer.State.Tab.incomeAndSpendings)

                GoalsView(
                    store: store.scope(state: \.goals, action: \.goals)
                )
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(MainTabBarReducer.State.Tab.goals)

                AnalyticsView(
                    //                    store: store.scope(state: \.analytics, action: \.analytics)
                )
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie")
                }
                .tag(MainTabBarReducer.State.Tab.analytics)

                StatisticsView(
                    //                    store: store.scope(state: \.statistics, action: \.statistics)
                )
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar")
                }
                .tag(MainTabBarReducer.State.Tab.statistics)
            }
            .tint(Constants.titleColor)
            .tabBarMinimizeBehavior(.onScrollDown)
        }
    }
}

#Preview {
    MainTabBarView(store: Store(initialState: MainTabBarReducer.State(), reducer: { MainTabBarReducer() }))
}
