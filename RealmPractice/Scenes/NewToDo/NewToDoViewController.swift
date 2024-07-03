//
//  NewToDoViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

enum NewToDoCellTitle: String, CaseIterable {
    case closingDate = "마감일"
    case tag = "태그"
    case priority = "우선 순위"
    case addImage = "이미지 추가"
}

final class NewToDoViewController: BaseViewController {
    
    let writeView = WriteToDoView(frame: .zero)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewToDoTableViewCell.self, forCellReuseIdentifier: NewToDoTableViewCell.identifier)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var todo: ToDo?
    
    var closingDate: Date?
    var tag: String?
    var priority: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(priorityNotification),
            name: Notification.Name("priority"),
            object: nil
        )
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "새로운 할 일"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonClicked)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(addButtonClicked)
        )
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        guard let title = writeView.titleTextField.text,
              let contents = writeView.contentsTextField.text,
              !title.isEmpty else {
            self.view.makeToast("제목을 입력해주세요")
            return
        }
        
        // Realm에 추가하기
        let realm = try! Realm()
        let todo = ToDo(title: title, contents: contents, closingDate: closingDate, tag: tag, priority: priority, date: Date())
        try! realm.write {
            realm.add(todo)
        }
        
        dismiss(animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(writeView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        writeView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(writeView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func priorityNotification(notification: NSNotification) {
        priority = notification.userInfo?[0] as? Int
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
}

extension NewToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewToDoCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewToDoTableViewCell.identifier,
            for: indexPath
        ) as? NewToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let option = NewToDoCellTitle.allCases[indexPath.row]
        let title = option.rawValue
        cell.configureTitle(title)
        
        switch option {
        case .closingDate:
            cell.configureDate(closingDate)
        case .tag:
            cell.configureTag(tag)
        case .priority:
            cell.configurePriority(priority)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = NewToDoCellTitle.allCases[indexPath.row]
        switch title {
        case .closingDate:
            // 1. closure
            let vc = DateViewController()
            vc.sendDate = { data in
                self.closingDate = data
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .tag:
            // 2. delegate
            let vc = TagViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        case .priority:
            // 3. notification
            let vc = PriorityViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension NewToDoViewController: TagDelegate {
    func sendTag(data: String) {
        tag = data
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}
