//
//  IncomeType.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

enum IncomeType: String, Codable, CaseIterable, Equatable {
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment"
    case rental = "Rental"
    case other = "Other"
}

enum SpendingType: String, Codable, CaseIterable, Equatable {
    case food = "Food"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case education = "Education"
    case shopping = "Shopping"
    case travel = "Travel"
    case other = "Other"
}

enum CategoryType: Equatable, Codable, Hashable {
    case income(IncomeType)
    case spending(SpendingType)

    var name: String {
        switch self {
        case .income(let type):
            return type.rawValue
        case .spending(let type):
            return type.rawValue
        }
    }
}

extension CategoryType {
    static var allIncome: [CategoryType] {
        IncomeType.allCases.map { .income($0) }
    }

    static var allSpending: [CategoryType] {
        SpendingType.allCases.map { .spending($0) }
    }
}
