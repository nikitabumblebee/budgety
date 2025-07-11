//
//  GoalCreationFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GoalCreationFeature {
    @ObservableState
    struct State: Equatable {
        var goalInfo: GoalInfo
        var isNew: Bool

        init(goalInfo: GoalInfo) {
            self.goalInfo = goalInfo
            isNew = goalInfo.title.isEmpty
        }
    }

    enum Action: BindableAction, Equatable {
        case save
        case delegate(Delegate)
        case binding(BindingAction<State>)

        enum Delegate: Equatable {
            case didSave(GoalInfo)
        }
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .save:
                return .send(.delegate(.didSave(state.goalInfo)))

            case .binding(\.goalInfo.title):
                return .none

            case .binding(\.goalInfo.current):
                return .none

            case .binding(\.goalInfo.target):
                return .none

            case .binding(\.goalInfo.color):
                return .none

            default:
                return .none
            }
        }
    }
}
