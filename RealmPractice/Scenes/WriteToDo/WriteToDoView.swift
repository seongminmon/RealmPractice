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
    
    lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        return textView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let textViewPlaceHolder = "내용"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
        
        addSubview(titleTextField)
        addSubview(contentsTextView)
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
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview().inset(8)
        }
    }
}

extension WriteToDoView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}
