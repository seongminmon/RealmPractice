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
    
    var naviTitle: String?      // 이전 화면에서 전달
    var todos: Results<ToDo>!   // 이전 화면에서 filter된 채로 전달
    
    var sortedTodos: Results<ToDo>!
    let repository = ToDoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedTodos = todos
        repository.configureNotification {
            self.tableView.reloadData()
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = naviTitle
        
        // pull down 버튼 만들기
        let total = UIAction(title: "전체") { _ in
            print("전체")
            self.sortedTodos = self.todos
            self.tableView.reloadData()
        }
        let titleSort = UIAction(title: "제목 순으로 보기") { _ in
            print("제목 순으로 보기")
            self.sortedTodos = self.todos.sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        }
        let dateSort = UIAction(title: "마감일 순으로 보기") { _ in
            print("마감일 순으로 보기")
            self.sortedTodos = self.todos.sorted(byKeyPath: "closingDate", ascending: true)
            self.tableView.reloadData()
        }
        let cancel = UIAction(title: "취소") { _ in
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
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoTableViewCell.identifier,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let data = sortedTodos[indexPath.row]
        cell.configureCell(data: data)
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        let item = sortedTodos[sender.tag]
        repository.toggleIsCompleteItem(item)
        sender.tintColor = item.isComplete ? .systemBlue : .gray
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: 스와이프로 깃발 표시 기능 구현하기
        if editingStyle == .delete {
            let item = sortedTodos[indexPath.row]
            repository.deleteItem(item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 수정 화면으로 이동하기
        let vc = WriteToDoViewController()
        vc.todo = sortedTodos[indexPath.row]
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}
