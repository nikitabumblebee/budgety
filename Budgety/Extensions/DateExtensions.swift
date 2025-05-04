//
//  DateExtensions.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

extension Date {
    func createMonthAndYearPresentation() -> String {
        return DateFormatter.string(from: self, format: .dateFormat("LLLL yyyy"))
    }
}
