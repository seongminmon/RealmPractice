//
//  Folder.swift
//  RealmPractice
//
//  Created by 김성민 on 7/8/24.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var closingDate: Date?
    @Persisted var isComplete: Bool
    @Persisted var flag: Bool
    @Persisted var regDate: Date
    
    convenience init(name: String, closingDate: Date? = nil, isComplete: Bool, flag: Bool) {
        self.init()
        self.name = name
        self.closingDate = closingDate
        self.isComplete = isComplete
        self.flag = flag
        self.regDate = Date()
    }
}
