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

final class NewToDoViewController: UIViewController {
    
    let writeView = WriteToDoView(frame: .zero)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewToDoTableViewCell.self, forCellReuseIdentifier: NewToDoTableViewCell.id)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        configureLayout()
        configureView()
    }
    
    func configureNavigationBar() {
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
        let todo = ToDo(title: title, contents: contents, date: Date())
        try! realm.write {
            realm.add(todo)
        }
        
        dismiss(animated: true)
    }
    
    func addSubviews() {
        view.addSubview(writeView)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        writeView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(writeView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
}

extension NewToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewToDoCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewToDoTableViewCell.id,
            for: indexPath
        ) as? NewToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let data = NewToDoCellTitle.allCases[indexPath.row].rawValue
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = NewToDoCellTitle.allCases[indexPath.row]
        switch title {
        case .closingDate:
            let vc = ClosingDateViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
