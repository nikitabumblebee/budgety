//
//  IncomeCategory.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

protocol CategoryProtocol: Codable, Equatable, Hashable {
    var id: String { get }
    var type: CategoryType { get }
    var amount: Double { get }
    var date: Date { get }
    var name: String { get }
}

struct IncomeCategory: CategoryProtocol {
    let id: String
    let type: CategoryType
    let amount: Double
    let date: Date

    var name: String {
        type.name
    }
}

struct SpendingCategory: CategoryProtocol {
    let id: String
    let type: CategoryType
    let amount: Double
    let date: Date

    var name: String {
        type.name
    }

    var color: String {
        switch type {
        case .income: "#FFFFFF"
        case .spending(let spendingType):
            switch spendingType {
            case .food:
                "#DBEAFE"
            case .transport:
                "#FEF9CE"
            case .entertainment:
                "#FCE7F3"
            case .utilities:
                "#F3E8FF"
            case .healthcare:
                "#F3E8FF"
            case .education:
                "#F3E8FF"
            case .shopping:
                "#F3E8FF"
            case .travel:
                "#F3E8FF"
            case .other:
                "#F3E8FF"
            }
        }
    }
    var textColor: String {
        switch type {
        case .income: "#FFFFFF"
        case .spending(let spendingType):
            switch spendingType {
            case .food:
                "#1D4ED8"
            case .transport:
                "#A16207"
            case .entertainment:
                "#BE185D"
            case .utilities:
                "#852DD1"
            case .healthcare:
                "#852DD1"
            case .education:
                "#852DD1"
            case .shopping:
                "#852DD1"
            case .travel:
                "#852DD1"
            case .other:
                "#852DD1"
            }
        }
    }
}

enum BalanceCategory: Equatable, Codable, Hashable {
    case income(IncomeCategory)
    case spending(SpendingCategory)

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
