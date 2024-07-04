//
//  ToDoRepository.swift
//  RealmPractice
//
//  Created by 김성민 on 7/4/24.
//

import Foundation
import RealmSwift

final class ToDoRepository {
    private let realm = try! Realm()
    
//    var list: Results<ToDo> {
//        return realm.objects(ToDo.self)
//    }
    
    var fileURL: URL? {
        return realm.configuration.fileURL
    }
    
    var schemaVersion: UInt64? {
        do {
            let version = try schemaVersionAtURL(fileURL!)
            return version
        } catch {
            return nil
        }
    }
    
    // MARK: - Create
    func addItem(_ item: ToDo) {
        try! realm.write {
            realm.add(item)
            print("Realm Create!")
        }
    }
    
    // MARK: - Read
    func fetchAll() -> Results<ToDo> {
        return realm.objects(ToDo.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    // MARK: - Update
    func updateItem(
        _ item: ToDo,
        title: String,
        contents: String?,
        closingDate: Date?,
        tag: String?,
        priority: Int?
    ) {
        // id와 isComplete는 바꾸지 X
        // date는 수정하는 날짜로 갱신
        // 나머지는 입력받아서 변경
        try! realm.write {
            item.title = title
            item.contents = contents
            item.closingDate = closingDate
            item.tag = tag
            item.priority = priority
            item.date = Date()
            
            print("Realm Update!")
        }
    }
    
    func toggleIsCompleteItem(_ item: ToDo) {
        try! realm.write {
            item.isComplete.toggle()
        }
    }
    
    // MARK: - Delete
    func deleteItem(_ item: ToDo) {
        try! realm.write {
            realm.delete(item)
            print("Realm Delete!")
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
            print("Realm Delete All!")
        }
    }
    
}
