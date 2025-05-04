//
//  MonthHistory.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

struct MonthHistory: Codable, Equatable {
    static func == (lhs: MonthHistory, rhs: MonthHistory) -> Bool {
        lhs.month == rhs.month
    }

    let month: Date
    let incomeCategories: [IncomeCategory]
    let spendingCategories: [SpendingCategory]

    var income: Double {
        incomeCategories.reduce(0) { $0 + $1.amount }
    }

    var spendings: Double {
        spendingCategories.reduce(0) { $0 + $1.amount }
    }
}
