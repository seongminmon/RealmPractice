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
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    // 이전 화면에서 전달
    var naviTitle: String?
    var sortOption: SortOption!
    var selectedDate: Date?
    var realmNotify: (() -> Void)?
    
    let repository = ToDoRepository()
    var originTodos: Results<ToDo>!     // sortOption으로 filter된 todos
    var sortedTodos: Results<ToDo>!     // pull down 버튼으로 정렬시
    var searchedTodos: Results<ToDo>!   // 서치바로 검색 시
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = selectedDate {
            // main에서 FS캘린더에서 날짜 선택했을 때
            originTodos = repository.fetchFilteredDate(date)
        } else {
            // main에서 컬렉션 뷰 셀 눌렀을 때
            originTodos = repository.fetchFiltered(sortOption: sortOption)
        }
        sortedTodos = originTodos
        searchedTodos = sortedTodos
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 메인 뷰에 변경되었다고 알려주기
        realmNotify?()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = naviTitle
        
        // searchController 설정
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "할 일을 검색해보세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // pull down 버튼 만들기
        let total = UIAction(title: "전체") { _ in
            print("전체")
            self.sortedTodos = self.originTodos
            self.searchedTodos = self.sortedTodos
            self.tableView.reloadData()
        }
        let titleSort = UIAction(title: "제목 순으로 보기") { _ in
            print("제목 순으로 보기")
            self.sortedTodos = self.originTodos.sorted(byKeyPath: "title", ascending: true)
            self.searchedTodos = self.sortedTodos
            self.tableView.reloadData()
        }
        let dateSort = UIAction(title: "마감일 순으로 보기") { _ in
            print("마감일 순으로 보기")
            self.sortedTodos = self.originTodos.sorted(byKeyPath: "closingDate", ascending: true)
            self.searchedTodos = self.sortedTodos
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
        return searchedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoTableViewCell.identifier,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let data = searchedTodos[indexPath.row]
        cell.configureCell(data: data)
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    // 스와이프 기능 (깃발 표시, 삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = searchedTodos[indexPath.row]
        
        let flag = UIContextualAction(style: .normal, title: nil) { _, _, success in
            // 깃발 표시 토글
            self.repository.toggleFlagItem(item)
            // '깃발 표시' 일 때는 테이블뷰에서 없애주기
            if self.sortOption == .flag {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            success(true)
        }
        flag.image = UIImage(systemName: "flag.fill")!
        flag.backgroundColor = .systemYellow
        
        let delete = UIContextualAction(style: .normal, title: nil) { _, _, success in
            // 삭제
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
        vc.todo = searchedTodos[indexPath.row]
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
        let item = searchedTodos[indexPath.row]
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

extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text)
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchedTodos = repository.fetchFilteredText(sortedTodos, text)
        } else {
            searchedTodos = sortedTodos
        }
        tableView.reloadData()
    }
}
