//
//  ToDoRepository.swift
//  RealmPractice
//
//  Created by 김성민 on 7/4/24.
//

import Foundation
import RealmSwift

enum SortOption: CaseIterable {
    case today
    case coming
    case total
    case flag
    case completed
}

final class ToDoRepository {
    
    private let realm = try! Realm()
    var todos: Results<ToDo> {
        return realm.objects(ToDo.self)
    }
    
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
        return realm.objects(ToDo.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func fetchFiltered(sortOption: SortOption) -> Results<ToDo> {
        let objects = fetchAll()
        switch sortOption {
        case .today:
            // TODO: 오늘을 마감일로 설정한 목록
            return objects.where {
                $0.date == Date()
            }
        case .coming:
            // TODO: 마감일이 설정되어 있고, 마감일이 미래인 목록
            return objects.where {
                $0.date > Date()
            }
        case .total:
            // 전체 목록
            return objects
        case .flag:
            // 깃발이 설정된 목록
            return objects.where {
                $0.flag
            }
        case .completed:
            // 할 일이 완료된 목록
            return objects.where {
                $0.isComplete
            }
        }
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
        // id, date(생성일), isComplete, flag는 바꾸지 X
        // 나머지는 입력받아서 변경
        try! realm.write {
            item.title = title
            item.contents = contents
            item.closingDate = closingDate
            item.tag = tag
            item.priority = priority
            
            print("Realm Update!")
        }
    }
    
    // (2) create(type:, value:, update:)로 업데이트 하는 방법
//    func updateItem2(
//        _ item: ToDo,
//        title: String,
//        contents: String?,
//        closingDate: Date?,
//        tag: String?,
//        priority: Int?
//    ) {
//        try! realm.write {
//            realm.create(
//                ToDo.self,
//                value: [
//                    "title": title,
//                    "contents": contents,
//                    "closingDate": closingDate,
//                    "tag": tag,
//                    "priority": priority
//                ],
//                update: .modified
//            )
//            print("Realm Update!")
//        }
//    }
    
    func toggleIsCompleteItem(_ item: ToDo) {
        try! realm.write {
            item.isComplete.toggle()
            print("Realm Toggle isComplete!")
        }
    }
    
    func toggleFlagItem(_ item: ToDo) {
        try! realm.write {
            item.flag.toggle()
            print("Realm Toggle flag!")
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
    
    // TODO: - 이미지 파일 매니저로 핸들링
    
}
