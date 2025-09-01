//
//  AllMonthsHistoryFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 01.09.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AllMonthsHistoryFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var monthsHistory: [MonthHistory] = []
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case openMonthDetails
    }

    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case openMonthDetails(MonthHistoryDescriptionFeature.State)
        }

        enum Action: Equatable {
            case openMonthDetails(MonthHistoryDescriptionFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.openMonthDetails, action: \.openMonthDetails) {
                MonthHistoryDescriptionFeature()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .openMonthDetails:
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
