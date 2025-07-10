//
//  FinancialOperationFeature.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FinancialOperationFeature {
    @ObservableState
    struct State: Equatable {
        var moneyDeposit: Double = 0
        var dateOperation: Date = Date()
        var categoryOperation: CategoryType = .income(.salary)
        var categories: [CategoryType] = CategoryType.allIncome
        var operationType: OperationType = .income

        init(operationType: OperationType) {
            self.operationType = operationType
            switch operationType {
            case .income:
                categoryOperation = .income(.salary)
                categories = CategoryType.allIncome
            case .spending:
                categoryOperation = .spending(.food)
                categories = CategoryType.allSpending
            }
        }
    }

    enum Action: BindableAction, Equatable {
        case depositChange(Double)
        case save
        case binding(BindingAction<State>)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case didSave(BalanceCategory)
        }
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .save:
                let balanceCategory: BalanceCategory
                switch state.operationType {
                case .income:
                    let incomeCategory = IncomeTransaction(id: UUID().uuidString, type: state.categoryOperation, amount: state.moneyDeposit, date: state.dateOperation)
                    balanceCategory = .income(incomeCategory)
                case .spending:
                    let spendingCategory = SpendingTransaction(id: UUID().uuidString, type: state.categoryOperation, amount: state.moneyDeposit, date: state.dateOperation)
                    balanceCategory = .spending(spendingCategory)
                }
                return .send(.delegate(.didSave(balanceCategory)))

            case .delegate:
                return .none

            case .binding(\.moneyDeposit):
                return .none

            case .binding(\.dateOperation):
                return .none

            case .binding(\.categoryOperation):
                return .none

            default:
                return .none
            }
        }
    }
}
