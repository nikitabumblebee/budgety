//
//  GoalInfo.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import Foundation

struct GoalInfo: Codable, Identifiable, Equatable {
    static func == (lhs: GoalInfo, rhs: GoalInfo) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    var title: String
    var color: String
    var saved: Double
    var target: Double

    var progress: Double {
        target == 0 ? 0 : saved / target
    }

    var formattedProgress: String {
        "Saved: $\(Int(saved)) / $\(Int(target))"
    }
}
