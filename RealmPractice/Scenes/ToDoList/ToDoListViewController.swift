//
//  ToDoListViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ToDoListViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    var naviTitle: String?
    let realm = try! Realm()
    var todos: Results<ToDo>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = realm.objects(ToDo.self)
        
        notificationToken = todos?.observe { [unowned self] changes in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                
            case .update:
                print("UPDATE")
                self.tableView.reloadData()
                
//                if deletions.count > 0 {
//                    deleteRow(at: deletions)
//                }
//                
//                if insertions.count > 0 {
//                    insertRow(at: insertions)
//                }
//                
//                if modifications.count > 0 {
//                    updateRow(at: modifications)
//                }
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = naviTitle
        
        // pull down 버튼 만들기
        let total = UIAction(title: "전체") { _ in
            print("전체")
            self.todos = self.realm.objects(ToDo.self)
            self.tableView.reloadData()
        }
        let titleSort = UIAction(title: "제목 순으로 보기") { _ in
            print("제목 순으로 보기")
            self.todos = self.realm.objects(ToDo.self)
                .sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        }
        let dateSort = UIAction(title: "마감일 순으로 보기") { _ in
            print("마감일 순으로 보기")
            self.todos = self.realm.objects(ToDo.self)
                .sorted(byKeyPath: "closingDate", ascending: true)
            self.tableView.reloadData()
        }
        let cancel = UIAction(title: "취소", attributes: .destructive) { _ in
            print("취소")
        }
        let menu = UIMenu(children: [total, titleSort, dateSort, cancel])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: menu
        )
    }
    
    override func addSubviews() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .systemBackground
    }
    
//    func insertRow(at indexs: [Int]) {
//        tableView.beginUpdates()
//        let indexPaths = indexs.map { IndexPath(item: $0, section: 0) }
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        tableView.endUpdates()
//    }
//    
//    func deleteRow(at indexs: [Int]) {
//        tableView.beginUpdates()
//        let indexPaths = indexs.map { IndexPath(item: $0, section: 0) }
//        tableView.deleteRows(at: indexPaths, with: .automatic)
//        tableView.endUpdates()
//    }
//    
//    func updateRow(at indexs: [Int]) {
//        let indexPaths = indexs.map { IndexPath(item: $0, section: 0) }
//        tableView.reloadRows(at: indexPaths, with: .automatic)
//    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoTableViewCell.identifier,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let data = todos[indexPath.row]
        cell.configureCell(data: data)
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        let target = todos[sender.tag]
        print(target)
        if sender.tintColor == .gray {
            sender.tintColor = .systemBlue
            try! realm.write {
                target.isComplete = true
            }
        } else {
            sender.tintColor = .gray
            try! realm.write {
                target.isComplete = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(todos[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 디테일 화면으로 이동하기
        let vc = DetailToDoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
