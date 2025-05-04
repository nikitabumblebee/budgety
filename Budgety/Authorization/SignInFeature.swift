//
//  SignInFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SignInFeature {
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var fullName: String = ""
    }

    @CasePathable
    enum Action: Equatable {
        case login
        case error(String)
        case delegateLogin(DelegateLogin)

        enum DelegateLogin: Equatable {
            case didLogin
        }
    }

    @Reducer
    enum Path {
        case signIn
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .login:
                // Handle login logic here
                return .send(.delegateLogin(.didLogin))

            case .error(let message):
                // Handle error logic here
                print("Error: \(message)")
                return .none

            case .delegateLogin:
                return .none
            }
        }
    }
}
