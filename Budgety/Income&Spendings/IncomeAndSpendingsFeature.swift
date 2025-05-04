//
//  IncomeAndSpendingsFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct IncomeAndSpendingsFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var spendings: Double
        var income: Double
        var incomeCategories: [IncomeCategory]
        var spendingCategories: [SpendingCategory]
        var monthHistory: [MonthHistory]
        var currentIncomeTypes: [String]

        init(
            incomeCategories: [IncomeCategory],
            spendingCategories: [SpendingCategory],
            monthHistory: [MonthHistory]
        ) {
            self.incomeCategories = incomeCategories
            self.spendingCategories = spendingCategories
            self.monthHistory = monthHistory
            self.income = incomeCategories.reduce(0) { $0 + $1.amount }
            self.spendings = spendingCategories.reduce(0) { $0 + $1.amount }
            self.currentIncomeTypes = incomeCategories.map { $0.type.name }
        }
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case addIncome
        case addSpending
    }

    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case addIncome(FinancialOperation.State)
            case addSpendings(FinancialOperation.State)
        }

        enum Action: Equatable {
            case addIncome(FinancialOperation.Action)
            case addSpendings(FinancialOperation.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.addIncome, action: \.addIncome) {
                FinancialOperation()
            }
            Scope(state: \.addSpendings, action: \.addSpendings) {
                FinancialOperation()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addIncome:
                state.path.append(.addIncome(FinancialOperation.State(operationType: .income)))
                return .none

            case .addSpending:
                state.path.append(.addSpendings(FinancialOperation.State(operationType: .spending)))
                return .none

            case .path(.element(_, .addIncome(.delegate(.didSave(let incomeCategory))))):
                state.income += incomeCategory.amount
                state.path.popLast()
                return .none

            case .path(.element(_, .addSpendings(.delegate(.didSave(let spendingsCategory))))):
                state.spendings += spendingsCategory.amount
                state.path.popLast()
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

let mockHomeFeatureState: IncomeAndSpendingsFeature.State = .init(
    incomeCategories: [
        IncomeCategory(id: UUID().uuidString, type: .income(.salary), amount: 5000, date: Date())
    ],
    spendingCategories: [
        SpendingCategory(id: UUID().uuidString, type: .spending(.food), amount: 420, date: Date()),
        SpendingCategory(id: UUID().uuidString, type: .spending(.transport), amount: 100, date: Date()),
        SpendingCategory(id: UUID().uuidString, type: .spending(.entertainment), amount: 43, date: Date()),
        SpendingCategory(id: UUID().uuidString, type: .spending(.shopping), amount: 180, date: Date())
    ],
    monthHistory: [
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeCategory(id: UUID().uuidString, type: .income(.salary), amount: 5000, date: Date())
            ],
            spendingCategories: [
                SpendingCategory(id: UUID().uuidString, type: .spending(.food), amount: 250, date: Date()),
                SpendingCategory(id: UUID().uuidString, type: .spending(.transport), amount: 125, date: Date())
            ]
        ),
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeCategory(id: UUID().uuidString, type: .income(.salary), amount: 6000, date: Date())
            ],
            spendingCategories: [
                SpendingCategory(id: UUID().uuidString, type: .spending(.food), amount: 350, date: Date()),
                SpendingCategory(id: UUID().uuidString, type: .spending(.transport), amount: 225, date: Date())
            ]
        ),
        MonthHistory(
            month: Date(),
            incomeCategories: [
                IncomeCategory(id: UUID().uuidString, type: .income(.salary), amount: 7000, date: Date())
            ],
            spendingCategories: [
                SpendingCategory(id: UUID().uuidString, type: .spending(.food), amount: 450, date: Date()),
                SpendingCategory(id: UUID().uuidString, type: .spending(.transport), amount: 325, date: Date())
            ]
        )
    ]
)
