//
//  MainViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "전체"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(newTodoButton)
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
    }
    
    override func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func newTodoButtonClicked() {
        // 새로운 할 일 화면 띄우기
        let vc = NewToDoViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.backgroundColor = .magenta
        return cell
    }
}
