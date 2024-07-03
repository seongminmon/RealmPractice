//
//  ToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class ToDoTableViewCell: BaseTableViewCell {
    
    lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "circle")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override func addSubviews() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaInsets).inset(16)
            make.height.equalTo(20)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaInsets).inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(4)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaInsets).inset(16)
            make.bottom.equalTo(contentView.safeAreaInsets).inset(8)
        }
    }
    
    @objc func completeButtonClicked() {
        if completeButton.tintColor == .gray {
            completeButton.tintColor = .systemBlue
        } else {
            completeButton.tintColor = .gray
        }
    }

    func configureCell(data: ToDo) {
        titleLabel.text = data.title
        contentsLabel.text = data.contents
        dateLabel.text = data.closingDate?.dateToString()
    }
}
