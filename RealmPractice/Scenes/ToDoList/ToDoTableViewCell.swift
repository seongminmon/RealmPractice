//
//  ToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ToDoTableViewCell: BaseTableViewCell {
    
    let completeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "circle.fill")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
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
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(completeButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func configureCell(data: ToDo) {
        completeButton.tintColor = data.isComplete ? .systemBlue : .gray
        
        var priorityText = ""
        if let priority = data.priority {
            priorityText = ToDoPriority.allCases[priority].text + " "
        }
        titleLabel.text = priorityText + data.title
        titleLabel.asColor(targetString: priorityText, color: .systemBlue)
        
        contentsLabel.text = data.contents
        
        var dateText = ""
        if let closingDate = data.closingDate {
            dateText = closingDate.dateToString()
        }
        var tagText = ""
        if let tag = data.tag {
            tagText = " #" + tag
        }
        dateLabel.text = dateText + tagText
        dateLabel.asColor(targetString: tagText, color: .systemBlue)
    }
}
