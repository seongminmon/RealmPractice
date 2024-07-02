//
//  MainViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
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
        addSubviews()
        configureLayout()
        configureView()
    }
    
    func addSubviews() {
        view.addSubview(newTodoButton)
    }
    
    func configureLayout() {
        newTodoButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.width.equalTo(140)
            make.height.equalTo(30)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func newTodoButtonClicked() {
        print(#function)
    }
    
}
