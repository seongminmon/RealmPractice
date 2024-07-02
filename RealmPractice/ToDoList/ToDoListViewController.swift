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

    override func viewDidLoad() {
        super.viewDidLoad()
        todos = realm.objects(ToDo.self)
        print(realm.configuration.fileURL)
        print(todos)
        
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
