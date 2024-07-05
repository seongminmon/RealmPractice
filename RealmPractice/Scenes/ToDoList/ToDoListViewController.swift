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
    
    // 이전 화면에서 전달
    var naviTitle: String?
    var sortOption: SortOption!
    var realmNotify: (() -> Void)?
    
    let repository = ToDoRepository()
    var originTodos: Results<ToDo>!
    var sortedTodos: Results<ToDo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originTodos = repository.fetchFiltered(sortOption: sortOption)
        sortedTodos = originTodos
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 메인 뷰에 변경되었다고 알려주기
        realmNotify?()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = naviTitle
        
        // pull down 버튼 만들기
        let total = UIAction(title: "전체") { _ in
            print("전체")
            self.sortedTodos = self.originTodos
            self.tableView.reloadData()
        }
        let titleSort = UIAction(title: "제목 순으로 보기") { _ in
            print("제목 순으로 보기")
            self.sortedTodos = self.originTodos.sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        }
        let dateSort = UIAction(title: "마감일 순으로 보기") { _ in
            print("마감일 순으로 보기")
            self.sortedTodos = self.originTodos.sorted(byKeyPath: "closingDate", ascending: true)
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
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    // 스와이프 기능 (깃발 표시, 삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = sortedTodos[indexPath.row]
        
        let flag = UIContextualAction(style: .normal, title: nil) { _, _, success in
            self.repository.toggleFlagItem(item)
            // '깃발 표시' 일 때는 테이블뷰에서 없애주기
            if self.sortOption == .flag {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            success(true)
        }
        flag.image = UIImage(systemName: "flag.fill")!
        flag.backgroundColor = .systemYellow
        
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.deleteItem(item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        }
        delete.image = UIImage(systemName: "trash.fill")!
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, flag])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 수정 화면으로 이동하기
        let vc = WriteToDoViewController()
        vc.todo = sortedTodos[indexPath.row]
        vc.realmNotify = {
            print("ToDoList", #function)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        vc.realmDeleteNotify = {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension ToDoListViewController: ToDoTableViewCellDelegate {
    func completeButtonClicked(_ indexPath: IndexPath) {
        let item = sortedTodos[indexPath.row]
        repository.toggleIsCompleteItem(item)
        
        // TODO: row만 바꿀 수 있는 방법 찾아보기
        // >>> row만 바꾸면 '완료됨'일때 indexPath 꼬임
        tableView.reloadData()
        
        // '완료됨' 일 때는 테이블뷰에서 없애주기
//        if sortOption == .completed {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
}
