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
    
    // TODO: observe를 여러번 했을 때 문제가 생길 수도?
    // 전역적으로 한번만 해야 하는 건가??
    // 맞네... observe가 안 사라짐...
    // (mainview, todolistview에서 호출 중)
    
    // 그럼 appdelegate나 scenedelegate에서 한번만 부른다 치면
    // completionHandler를 어떻게 해야하지?
    // token으로 observe를 한번하면 평생 추적한다,,,
    
    // completionHandler로 뷰 갱신 해야돼서
    // 뷰컨에서 함수를 정의해주어야 한다,,,
    
    // *****
    // observe는 한번만 호출해야하고,
    // handler는 VC에서 정해줘야 한다..
    // vc에서 각각 token을 갖고 해야 하나?
    // vc에서 가지면 vc 사라질때 observe도 사라지지 않을까?
//    var notificationToken: NotificationToken?
//    
//    func configureNotification(completionHandler: @escaping () -> Void) {
//        notificationToken = todos.observe { changes in
//            switch changes {
//                
//            case .initial(let todos):
//                print("Initial count: \(todos.count)")
//                
//            case .update(let todos, let deletions, let insertions, let modifications):
//                print("Update count: \(todos.count)")
//                print("Delete count: \(deletions.count)")
//                print("Insert count: \(insertions.count)")
//                print("Modification count: \(modifications.count)")
//                completionHandler()
//                
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
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
//                    "priority": priority,
//                    "date": Date(),
//                ],
//                update: .modified
//            )
//            print("Realm Update!")
//        }
//    }
    
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
    
    // TODO: - 이미지 파일 매니저로 핸들링
    
}
