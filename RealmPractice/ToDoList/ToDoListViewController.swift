//
//  ToDoListViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ToDoListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.id)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let realm = try! Realm()
    var todos: Results<ToDo>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(realm.configuration.fileURL)
//        print(todos)
        
        todos = realm.objects(ToDo.self)
        
        notificationToken = todos?.observe { [unowned self] changes in
            switch changes {
            case .initial(let todos):
                self.tableView.reloadData()
                
            case .update(let todos, let deletions, let insertions, let modifications):
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
        
        configureNavigationBar()
        addSubviews()
        configureLayout()
        configureView()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "New",
            style: .plain,
            target: self,
            action: #selector(newButtonClicked)
        )
    }
    
    @objc func newButtonClicked() {
        // 새로운 할 일 화면 띄우기
        let vc = NewToDoViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
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
            withIdentifier: ToDoTableViewCell.id,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let data = todos[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
}
