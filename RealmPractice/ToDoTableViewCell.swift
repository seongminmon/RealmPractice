//
//  ToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class ToDoTableViewCell: UITableViewCell {
    static let id = "ToDoTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(dateLabel)
        
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
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaInsets).inset(16)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(4)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaInsets).inset(16)
            make.height.equalTo(20)
            make.bottom.equalTo(contentView.safeAreaInsets).inset(8)
        }
        
        titleLabel.text = "타이틀 입니다."
        contentsLabel.text = "컨텐츠 라벨입니다"
        dateLabel.text = "2024.03.24"
//        completeButton.backgroundColor = .red
    }
    
    @objc func completeButtonClicked() {
        if completeButton.tintColor == .gray {
            completeButton.tintColor = .systemBlue
        } else {
            completeButton.tintColor = .gray
        }
    }

    // vc에서 데이터 받아서 데이터 세팅하기
    func configureCell(data: String?) {
        
    }
}
