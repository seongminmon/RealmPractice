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
    @Persisted var date: Date
    
    // 제목, 내용, 마감일, 태그, 우선 순위, 완료 여부, 깃발 표시
    @Persisted var title: String
    @Persisted var contents: String?
    @Persisted var closingDate: Date?
    @Persisted var tag: String?
    @Persisted var priority: Int?
    @Persisted var isComplete: Bool
    @Persisted var flag: Bool
    
    convenience init(
        title: String,
        contents: String?,
        closingDate: Date?,
        tag: String?,
        priority: Int?,
        date: Date
    ) {
        self.init()
        self.title = title
        self.contents = contents
        self.closingDate = closingDate
        self.tag = tag
        self.priority = priority
        self.date = date
        self.isComplete = false
        self.flag = false
    }
}
