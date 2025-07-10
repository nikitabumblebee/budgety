//
//  Category.swift
//  Budgety
//
//  Created by Nikita Shmelev on 10.07.2025.
//

import Foundation

protocol CategoryProtocol: Equatable, Hashable {
    var amount: Double { get }
    var type: CategoryType { get }
    var name: String { get }
}

struct IncomeCategory: CategoryProtocol {
    var amount: Double
    var type: CategoryType
    var name: String {
        type.name
    }
}

struct SpendingCategory: CategoryProtocol {
    var amount: Double
    var type: CategoryType
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
