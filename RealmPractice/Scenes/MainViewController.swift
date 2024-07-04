//
//  MainViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

struct MainCollection {
    let description: String
    let mainImage: UIImage
    let background: UIColor
    
    static let list: [MainCollection] = [
        MainCollection(description: "오늘", mainImage: UIImage(systemName: "calendar")!, background: .systemBlue),
        MainCollection(description: "예정", mainImage: UIImage(systemName: "calendar.badge.plus")!, background: .systemRed),
        MainCollection(description: "전체", mainImage: UIImage(systemName: "tray.fill")!, background: .gray),
        MainCollection(description: "깃발 표시", mainImage: UIImage(systemName: "flag.fill")!, background: .systemYellow),
        MainCollection(description: "완료됨", mainImage: UIImage(systemName: "checkmark")!, background: .gray)
    ]
}

final class MainViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: BaseCollectionViewCell.collectionViewLayout())
        view.delegate = self
        view.dataSource = self
        view.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        return view
    }()
    
    lazy var newTodoButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "새로운 할 일"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 8
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(newTodoButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var addListButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "목록 추가"
        config.titleAlignment = .trailing
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(addListButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let repository = ToDoRepository()
    
    // TODO: - 할 일 추가했을 때 count 뷰 업데이트
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(repository.fileURL!)
        print("스키마 버전: \(repository.schemaVersion!)")
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"), 
            style: .plain,
            target: self,
            action: #selector(calendarButtonClicked)
        )
    }
    
    @objc func calendarButtonClicked() {
        print(#function)
    }
    
    override func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(newTodoButton)
        view.addSubview(addListButton)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(newTodoButton.snp.top).offset(-16)
        }
        
        newTodoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }
        
        addListButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    override func configureView() {
    }
    
    @objc func newTodoButtonClicked() {
        // 새로운 할 일 화면 띄우기
        let vc = WriteToDoViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func addListButtonClicked() {
        print(#function)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainCollection.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let count = repository.fetchAll().count
        let data = MainCollection.list[indexPath.row]
        cell.configureCell(count: count, data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 할 일 리스트 화면 이동
        let vc = ToDoListViewController()
        vc.naviTitle = MainCollection.list[indexPath.row].description
        navigationController?.pushViewController(vc, animated: true)
    }
}
