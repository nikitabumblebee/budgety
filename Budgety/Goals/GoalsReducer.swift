//
//  GoalsReducer.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GoalsReducer {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var goals: [/*GoalCreationReducer.State*/GoalInfo]
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case addGoal
        case updateGoal(GoalInfo)
    }

    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case addGoal(GoalCreationReducer.State)
            case updateGoal(GoalCreationReducer.State)
        }

        enum Action: Equatable {
            case addGoal(GoalCreationReducer.Action)
            case updateGoal(GoalCreationReducer.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.addGoal, action: \.addGoal) {
                GoalCreationReducer()
            }
            Scope(state: \.updateGoal, action: \.updateGoal) {
                GoalCreationReducer()
            }
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addGoal:
                state.path.append(.addGoal(GoalCreationReducer.State(goalInfo: GoalInfo(id: UUID(), title: "", color: "#1D4ED8", saved: 0, target: 0))))
                return .none //.send(.delegate(.setTabBarHidden(true)))

            case let .updateGoal(goalInfo):
                state.path.append(.updateGoal(GoalCreationReducer.State(goalInfo: goalInfo)))
                return .none //.send(.delegate(.setTabBarHidden(true)))

//            case let .path(.element(_, .addGoal(.delegate(.setTabBarHidden(hidden))))),
//                let .path(.element(_, .updateGoal(.delegate(.setTabBarHidden(hidden))))):
//                return .send(.delegate(.setTabBarHidden(hidden)))

//            case let .delegate(delegateAction):
//                switch delegateAction {
//                case .dismissSelf:
//                    return .none
//                case .setTabBarHidden(let hidden):
//                    return .send(.delegate(.setTabBarHidden(hidden)))
//                }

            case .path(.element(_, .addGoal(.delegate(.didSave(let goalInfo))))):
                state.path.popLast()
                state.goals.append(goalInfo)
                return .none

            case .path(.element(_, .updateGoal(.delegate(.didSave(let goalInfo))))):
                state.path.popLast()
                if let existedGoalIndex = state.goals.firstIndex(where: { $0.id == goalInfo.id }) {
                    state.goals[existedGoalIndex] = goalInfo
                }
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

let mockGoals = GoalsReducer.State(goals: [
    GoalInfo(id: UUID(), title: "Abs", color: "#1D4ED8", saved: 50, target: 100),
    GoalInfo(id: UUID(), title: "Aasd", color: "#FEF9CE", saved: 70, target: 100)
])
