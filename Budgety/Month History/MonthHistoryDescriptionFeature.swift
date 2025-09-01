//
//  MonthHistoryDescriptionFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 01.09.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MonthHistoryDescriptionFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var monthHistory: MonthHistory = .init(month: Date(), incomeCategories: [IncomeTransaction(id: UUID().uuidString, type: .income(.salary), amount: 5000, date: Date())], spendingCategories: [SpendingTransaction(id: UUID().uuidString, type: .spending(.food), amount: 420, date: Date())])
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case openDetails
    }

    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case openDetails
        }

        enum Action: Equatable {
            case openDetails
        }

//        var body: some ReducerOf<Self> {
//            Scope(state: \.openDetails, action: \.openDetails) {
//                MonthHistoryDescriptionFeature()
//            }
//        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openDetails:
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
