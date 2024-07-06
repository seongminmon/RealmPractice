//
//  TagViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import UIKit
import SnapKit

protocol TagDelegate {
    func sendTag(data: String)
}

final class TagViewController: BaseViewController {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "태그를 입력해주세요."
        tf.backgroundColor = .darkGray
        tf.layer.cornerRadius = 10
        
        // 양 옆 padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.rightView = paddingView
        tf.rightViewMode = .always
        return tf
    }()
    
    var delegate: TagDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let data = textField.text, !data.isEmpty else { return }
        delegate?.sendTag(data: data)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "태그 설정하기"
    }
    
    override func addSubviews() {
        view.addSubview(textField)
    }
    
    override func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
