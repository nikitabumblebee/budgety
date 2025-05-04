//
//  DateFormatterExtension.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import Foundation

extension DateFormatter {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()

    static func get(
        with locale: Locale = Locale.current,
        timeZone: TimeZone = .current,
        dateStyle: Style = .none,
        timeStyle: Style = .none,
        format: DateFormat
    )
        -> DateFormatter {
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        switch format {
        case .localizedFromTemplate(let template):
            dateFormatter.setLocalizedDateFormatFromTemplate(template)
        case .dateFormat(let template):
            dateFormatter.dateFormat = template
        }
        return dateFormatter
    }

    static func string(
        from date: Date,
        with locale: Locale = Locale.current,
        timeZone: TimeZone = TimeZone.current,
        dateStyle: Style = .none,
        timeStyle: Style = .none,
        format: DateFormat
    )
        -> String {
        get(with: locale, timeZone: timeZone, dateStyle: dateStyle, timeStyle: timeStyle, format: format).string(from: date)
    }
}

// MARK: - DateFormat

enum DateFormat {
    case localizedFromTemplate(String)
    case dateFormat(String)
}
