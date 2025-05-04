//
//  MonthBudgetInfo.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import Foundation

struct MonthBudgetInfo: Codable {
    var month: Int
    var days: [DayBudgetInfo]
    var goals: [GoalInfo]
}
