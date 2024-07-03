//
//  ToDo.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var contents: String?
    @Persisted var closingDate: Date?
    @Persisted var date: Date
    
    convenience init(title: String, contents: String? = nil, closingDate: Date? = nil, date: Date) {
        self.init()
        self.title = title
        self.contents = contents
        self.closingDate = closingDate
        self.date = date
    }
}
