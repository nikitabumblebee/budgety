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
        var incomeTransactions: [IncomeTransaction]
        var spendingTransactions: [SpendingTransaction]
        var incomeCategories: [IncomeCategory]
        var spendingCategories: [SpendingCategory]
        var monthHistory: [MonthHistory]
        var currentIncomeTypes: [String]

        init(
            incomeTransactions: [IncomeTransaction],
            spendingTransactions: [SpendingTransaction],
            monthHistory: [MonthHistory]
        ) {
            self.incomeTransactions = incomeTransactions
            self.spendingTransactions = spendingTransactions
            self.monthHistory = monthHistory
            self.income = incomeTransactions.reduce(0) { $0 + $1.amount }
            self.spendings = spendingTransactions.reduce(0) { $0 + $1.amount }
            self.incomeCategories = incomeTransactions.map { IncomeCategory(amount: $0.amount, type: $0.type) }
            self.spendingCategories = spendingTransactions.map { SpendingCategory(amount: $0.amount, type: $0.type) }
            self.currentIncomeTypes = incomeTransactions
                .uniques(by: \.type)
                .map { SpendingCategory(amount: $0.amount, type: $0.type) }
                .map { $0.type.name }
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
            case addIncome(FinancialOperationFeature.State)
            case addSpendings(FinancialOperationFeature.State)
        }

        enum Action: Equatable {
            case addIncome(FinancialOperationFeature.Action)
            case addSpendings(FinancialOperationFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.addIncome, action: \.addIncome) {
                FinancialOperationFeature()
            }
            Scope(state: \.addSpendings, action: \.addSpendings) {
                FinancialOperationFeature()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addIncome:
                state.path.append(.addIncome(FinancialOperationFeature.State(operationType: .income)))
                return .none

            case .addSpending:
                state.path.append(.addSpendings(FinancialOperationFeature.State(operationType: .spending)))
                return .none

            case .path(.element(_, .addIncome(.delegate(.didSave(let tansaction))))):
                state.income += tansaction.amount
                switch tansaction {
                case .income(let income):
                    state.incomeTransactions.append(income)
                    if !state.currentIncomeTypes.contains(income.name) {
                        state.currentIncomeTypes.append(income.name)
                    }
                default: break
                }
                state.path.popLast()
                return .none

            case .path(.element(_, .addSpendings(.delegate(.didSave(let transaction))))):
                state.spendings += transaction.amount
                switch transaction {
                case .spending(let spending):
                    state.spendingTransactions.append(spending)
                    if let currentType = state.spendingCategories.first(where: { $0.type == spending.type }), let index = state.spendingCategories.firstIndex(where: { $0.type == spending.type }) {
                        let currentAmount = currentType.amount
                        let updatedType = SpendingCategory(
                            amount: currentAmount + spending.amount,
                            type: currentType.type,
                        )
                        state.spendingCategories.removeAll(where: { $0.type == currentType.type })
                        state.spendingCategories.insert(updatedType, at: index)
                    } else {
                        state.spendingCategories.append(SpendingCategory(amount: spending.amount, type: spending.type))
                    }
                default: break
                }
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
