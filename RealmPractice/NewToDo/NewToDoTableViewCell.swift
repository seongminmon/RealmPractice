//
//  NewToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

class NewToDoTableViewCell: UITableViewCell {
    static let id = "NewToDoTableViewCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    let contentsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모"
        return textField
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        containerView.addSubview(titleTextField)
        containerView.addSubview(contentsTextField)
        containerView.addSubview(separator)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }
        
        contentsTextField.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview().inset(8)
        }
    }

//    func configureCell(data: String?) {
//        
//    }
}
