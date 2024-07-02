//
//  ToDoListViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

class ToDoListViewController: UIViewController {

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(#function)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.id)
    }
    
    @objc func newTodoButtonClicked() {
        print(#function)
    }

}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoTableViewCell.id,
            for: indexPath
        ) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }
    
}
