//
//  Date+.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        return formatter.string(from: self)
    }
}
