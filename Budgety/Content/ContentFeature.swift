//
//  ContentFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ContentFeature {
    @Dependency(\.authClient) var authClient

    @ObservableState
    struct State: Equatable {
        var screen: AppScreen = .registration(SignInFeature.State())
        var registration: SignInFeature.State
        var mainTabBar: MainTabBarReducer.State
        
        init() {
            self.registration = SignInFeature.State()
            self.mainTabBar = MainTabBarReducer.State()
        }
    }

    @CasePathable
    enum AppScreen: Equatable {
        case registration(SignInFeature.State)
        case mainTabBar(MainTabBarReducer.State)
    }

    @CasePathable
    enum Action: Equatable {
        case registration(SignInFeature.Action)
        case mainTabBar(MainTabBarReducer.Action)
    }

    enum CancelID { case auth }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .registration(.delegateLogin(.didLogin)):
                state.screen = .mainTabBar(MainTabBarReducer.State())
                return .none

            default:
                return .none
            }
        }
        Scope(state: \.registration, action: \.registration) {
            SignInFeature()
        }
        Scope(state: \.mainTabBar, action: \.mainTabBar) {
            MainTabBarReducer()
        }
    }
}
