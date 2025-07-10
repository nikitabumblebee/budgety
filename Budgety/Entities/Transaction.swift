//
//  Transaction.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

protocol TansactionProtocol: Codable, Equatable, Hashable {
    var id: String { get }
    var type: CategoryType { get }
    var amount: Double { get }
    var date: Date { get }
    var name: String { get }
}

struct IncomeTransaction: TansactionProtocol {
    let id: String
    let type: CategoryType
    var amount: Double
    let date: Date

    var name: String {
        type.name
    }
}

struct SpendingTransaction: TansactionProtocol {
    let id: String
    let type: CategoryType
    var amount: Double
    let date: Date

    var name: String {
        type.name
    }
}

enum BalanceCategory: Equatable, Codable, Hashable {
    case income(IncomeTransaction)
    case spending(SpendingTransaction)

    var id: String {
        switch self {
        case .income(let income): return income.id
        case .spending(let spending): return spending.id
        }
    }

    var name: String {
        switch self {
        case .income(let income): return income.name
        case .spending(let spending): return spending.name
        }
    }

    var amount: Double {
        switch self {
        case .income(let income): return income.amount
        case .spending(let spending): return spending.amount
        }
    }

    var date: Date {
        switch self {
        case .income(let income): return income.date
        case .spending(let spending): return spending.date
        }
    }

    var type: CategoryType {
        switch self {
        case .income(let income): return income.type
        case .spending(let spending): return spending.type
        }
    }
}
