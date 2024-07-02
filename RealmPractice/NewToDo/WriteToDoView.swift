//
//  WriteToDoView.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class WriteToDoView: UIView {
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    // TODO: - TextView로 바꾸기
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(titleTextField)
        addSubview(contentsTextField)
        addSubview(separator)
        
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
}
