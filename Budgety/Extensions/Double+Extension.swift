//
//  Double+Extension.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.05.2025.
//

import Foundation

extension Double {
    var decimalRepresentation: String {
        String(format: "%.2f", self)
    }
}
