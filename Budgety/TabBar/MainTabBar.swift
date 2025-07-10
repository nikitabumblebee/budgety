//
//  MainTabBar.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MainTabBarReducer {
    @ObservableState
    struct State: Equatable {
        var path = StackState<MainTabBarPath.State>()
        var selectedTab: Tab = .incomeAndSpendings
//        var isTabBarHidden = false
        var incomeAndSpendings: IncomeAndSpendingsFeature.State
        var goals: GoalsReducer.State
//        var analytics = AnalyticsReducer.State()
//        var statistics = StatisticsReducer.State()

        enum Tab: Hashable {
            case incomeAndSpendings
            case goals
            case analytics
            case statistics
        }

        init() {
//            let incomeCategories: [IncomeCategory] = []
//            let spendingCategories: [SpendingCategory] = []
//            let monthHistory: [MonthHistory] = []

            self.incomeAndSpendings = mockIncomeAndSpendings
            self.goals = mockGoals
        }
    }

    enum Action: Equatable {
        case path(StackAction<MainTabBarPath.State, MainTabBarPath.Action>)
        case tabSelected(State.Tab)
        case incomeAndSpendings(IncomeAndSpendingsFeature.Action)
        case goals(GoalsReducer.Action)
//        case analytics(AnalyticsReducer.Action)
//        case statistics(StatisticsReducer.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.incomeAndSpendings, action: \.incomeAndSpendings) {
            IncomeAndSpendingsFeature()
        }

        Scope(state: \.goals, action: \.goals) {
            GoalsReducer()
        }
//
//        Scope(state: \.analytics, action: \.analytics) {
//            AnalyticsReducer()
//        }
//
//        Scope(state: \.statistics, action: \.statistics) {
//            StatisticsReducer()
//        }

        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            MainTabBarPath()
        }
    }
}

@Reducer
struct MainTabBarPath {
    @CasePathable
    enum State: Equatable {
        case goalDetails(GoalsReducer.State)
        case spendingDetails(IncomeAndSpendingsFeature.State)
    }

    @CasePathable
    enum Action: Equatable {
        case goalDetails(GoalsReducer.Action)
        case spendingDetails(IncomeAndSpendingsFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.goalDetails, action: \.goalDetails) {
            GoalsReducer()
        }
        Scope(state: \.spendingDetails, action: \.spendingDetails) {
            IncomeAndSpendingsFeature()
        }
    }
}

let mockIncomeAndSpendings = IncomeAndSpendingsFeature.State(
    incomeTransactions: [
        IncomeTransaction(id: UUID().uuidString, type: .income(.salary), amount: 5000, date: Date())
    ],
    spendingTransactions: [
        SpendingTransaction(id: UUID().uuidString, type: .spending(.food), amount: 420, date: Date()),
        SpendingTransaction(id: UUID().uuidString, type: .spending(.transport), amount: 100, date: Date()),
        SpendingTransaction(id: UUID().uuidString, type: .spending(.entertainment), amount: 43, date: Date()),
        SpendingTransaction(id: UUID().uuidString, type: .spending(.shopping), amount: 180, date: Date())
    ],
    monthHistory: [
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeTransaction(id: UUID().uuidString, type: .income(.salary), amount: 5000, date: Date())
            ],
            spendingCategories: [
                SpendingTransaction(id: UUID().uuidString, type: .spending(.food), amount: 250, date: Date()),
                SpendingTransaction(id: UUID().uuidString, type: .spending(.transport), amount: 125, date: Date())
            ]
        ),
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeTransaction(id: UUID().uuidString, type: .income(.salary), amount: 6000, date: Date())
            ],
            spendingCategories: [
                SpendingTransaction(id: UUID().uuidString, type: .spending(.food), amount: 350, date: Date()),
                SpendingTransaction(id: UUID().uuidString, type: .spending(.transport), amount: 225, date: Date())
            ]
        ),
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeTransaction(id: UUID().uuidString, type: .income(.salary), amount: 7000, date: Date())
            ],
            spendingCategories: [
                SpendingTransaction(id: UUID().uuidString, type: .spending(.food), amount: 450, date: Date()),
                SpendingTransaction(id: UUID().uuidString, type: .spending(.transport), amount: 325, date: Date())
            ]
        )
    ]
)
