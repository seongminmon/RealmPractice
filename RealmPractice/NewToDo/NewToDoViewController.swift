//
//  NewToDoViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit

class NewToDoViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewToDoTableViewCell.self, forCellReuseIdentifier: NewToDoTableViewCell.id)
        tableView.register(NewToDoDetailTableViewCell.self, forCellReuseIdentifier: NewToDoDetailTableViewCell.id)
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
        print(#function)
    }
    
    @objc func addButtonClicked() {
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
        view.backgroundColor = .systemBackground
    }
}

extension NewToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewToDoTableViewCell.id,
                for: indexPath
            ) as? NewToDoTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewToDoDetailTableViewCell.id,
                for: indexPath
            ) as? NewToDoDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(data: "마감일")
            return cell
        }
    }
    
}
