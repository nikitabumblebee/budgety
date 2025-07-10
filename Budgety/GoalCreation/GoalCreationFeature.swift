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
        var title: String
        var isNew: Bool

        init(goalInfo: GoalInfo) {
            self.goalInfo = goalInfo
            self.title = goalInfo.title
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
                state.goalInfo.title = state.title
                return .send(.delegate(.didSave(state.goalInfo)))

            case .binding(\.title):
                state.goalInfo.title = state.title
                return .none

            default:
                return .none
            }
        }
    }
}
