//
//  ClosingDateViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit

final class ClosingDateViewController: UIViewController {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    var sendDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        configureLayout()
        configureView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendDate?(datePicker.date)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "마감일 고르기"
    }
    
    func addSubviews() {
        view.addSubview(datePicker)
    }
    
    func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
}
